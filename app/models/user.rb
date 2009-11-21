# == Schema Information
# Schema version: 20091110082101
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  login             :string(40)
#  name              :string(100)     default("")
#  email             :string(100)
#  crypted_password  :string(40)
#  created_at        :datetime
#  updated_at        :datetime
#  birthdate         :date
#  gender            :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  perishable_token  :string(255)
#  active            :boolean(1)
#  type              :string(255)     default("User")
#  income_id         :integer(4)
#  zip_code          :string(255)
#

class User < ActiveRecord::Base

  attr_accessor :old_password, :security_token, :device

  acts_as_authentic do |authlogic|
    authlogic.check_passwords_against_database = false
    authlogic.crypto_provider = Authlogic::CryptoProviders::Sha1
    authlogic.perishable_token_valid_for = 1.month
    authlogic.disable_perishable_token_maintenance = true
  end

  has_many :created_surveys, :foreign_key => "owner_id", :class_name => "Survey"

  has_many :completions
  has_many :surveys, :through => :completions
  has_many :answers
  has_many :payments, :foreign_key => "owner_id", :class_name => "Payment"
  has_many :replies
  has_many :transfers, :through => :replies
  
  after_create :setup_user

  validates_numericality_of :zip_code, :if => Proc.new { |user| !user.zip_code.blank? }

  TYPES = ['Admin', 'User', 'Reviewer']

  Incomes = {
    0 => "Under $15,000",
    1 => "$15,000 - $24,999", 2 => "$25,000 - $29,999",
    3 => "$30,000 - $34,999", 4 => "$35,000 - $39,999",
    5 => "$40,000 - $44,999", 6 => "$45,000 - $49,999",
    7 => "$50,000 - $59,999",
    8 => "$60,000 - $74,999", 9 => "$75,000 - $99,999",
    10 => "$100,000 - $149,999", 11 => "$150,000 - $199,999",
    12 => "$200,000 or more"
  }

  def income=(income_string)
    self.income_id = Incomes.invert[income_string]
  end

  def income
    Incomes[income_id]
  end

  def activate(token)
    update_attribute(:active, true) if token == perishable_token
    active?
  end

  def send_reset_instructions
    reset_perishable_token!
    deliver_reset_instructions_mail
  end

  def valid_perishable_token?(token)
    perishable_token == token
  end

  def old_password_valid?
    valid_password? old_password
  end

  def is_admin?
    type == 'Admin'
  end

  def change_type(type_name)
    update_attribute(:type, type_name)
  end

  def deliver_new_password_email(new_password)
    UserMailer.deliver_new_password_email(self, new_password)
  end

  def to_json(options = {})
    options[:methods] ||= []
    options[:methods] << :income unless options[:methods].include? :income
    super
  end

  def pending_amount
    transfers.pending.inject(0) do |amount, transfer|
      amount += transfer.survey.total_payout
    end
  end
  
#  def completed_surveys
#    replies.find(:all, :select => 'replies.survey_id AS id',
#      :conditions => ['surveys.end_at > ?', Date.today],
#      :joins => ['INNER JOIN surveys ON replies.survey_id = surveys.id INNER JOIN questions ON surveys.id = questions.survey_id INNER JOIN answers ON replies.id = answers.reply_id'],
#      :group => 'replies.id',
#      :having => 'COUNT(DISTINCT(answers.id)) = COUNT(DISTINCT(questions.id))')  
#  end
   
  def completed_surveys
    replies.all(:select => 'replies.survey_id AS id',
      :joins => ['INNER JOIN surveys ON replies.survey_id = surveys.id'],
      :conditions => ['replies.status IN (?, ?) AND surveys.end_at > ?', 'paid', 'complete', Date.today])
  end
  
  def has_camera?
    /iphone/.match(device).nil? ? false : true
  end
  
  # Returns ids of un-replied and un-expired surveys
  # and those surveys that can be completed by user
  # Do not include surveys with photo-response-questions if user.has_camera? == false
  
  def unreplied_surveys
    unreplied_survey_ids = Survey.surveys_for(self).collect{|s| s.id if s.try(:id)}.compact - completed_surveys.ids
    unreplied_survey_ids.empty? ? nil : unreplied_survey_ids
  end

  private

  def setup_user
    reset_perishable_token!
    deliver_activation_mail
  end

  def deliver_activation_mail
    UserMailer.deliver_activation_mail(self)
  end

  def deliver_reset_instructions_mail
    reset_perishable_token!
    UserMailer.deliver_reset_instructions_mail(self)
  end

  def password_change_security
    if password
      unless new_record? or valid_perishable_token?(security_token) or old_password_valid?
        errors.add(:old_password, "is invalid")
      end
    end
  end

end

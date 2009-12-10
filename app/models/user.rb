# == Schema Information
# Schema version: 20091127040223
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
#  blacklisted       :boolean(1)
#

class User < ActiveRecord::Base

  ActiveRecord::Base.send(:extend, ConcernedWith) # If this line is not present 'concerned_with' is not recognized

  concerned_with :demographics

  attr_accessor :old_password, :security_token, :device

  acts_as_authentic do |authlogic|
    authlogic.check_passwords_against_database = false
    authlogic.crypto_provider = Authlogic::CryptoProviders::Sha1
    authlogic.perishable_token_valid_for = 1.month
    authlogic.disable_perishable_token_maintenance = true
  end

  has_many :created_surveys, :foreign_key => "owner_id", :class_name => "Survey"

  has_many :answers
  has_many :payments, :foreign_key => "owner_id", :class_name => "Payment"
  has_many :replies
  has_many :transfers, :through => :replies

  after_create :setup_user

  validates_numericality_of :zip_code, :if => Proc.new { |user| !user.zip_code.blank? }
  
  named_scope :consumers, :conditions => {:type => 'Consumer'}
  
  TYPES = ['Admin', 'User', 'Reviewer', 'Consumer']
  
  def is_admin?
    type == 'Admin'
  end
  
  def is_consumer?
    type == 'Consumer'
  end
  
  def is_reviewer?
    type == 'Reviewer'
  end
  
  def is_user?
    type == 'User'
  end
  
  def self.total_consumers
    consumers.all.size
  end
  
  def full_name
    (name.nil? || name.strip.empty?) ? login : name
  end
  
  def last_name
    name.split(' ').last unless name.nil? 
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

  def add_to_blacklist
    update_attribute(:blacklisted, true)
  end

  def change_type(type_name)
    update_attribute(:type, type_name)
  end

  def deliver_new_password_email(new_password)
    UserMailer.deliver_new_password_email(self, new_password)
  end

  def to_json(options = {})
    options[:methods] ||= []
    options[:methods] |= [:income, :race, :martial_status, :education, :occupation]
    super
  end

  def pending_amount
    transfers.pending.inject(0) do |amount, transfer|
      amount += transfer.survey.total_payout
    end
  end

  def completed_surveys
    replies.paid_or_complete.all(:select => 'replies.survey_id AS id',
      :joins => ['INNER JOIN surveys ON replies.survey_id = surveys.id'],
      :conditions => ['surveys.end_at > ?', Date.today])
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

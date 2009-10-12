# == Schema Information
# Schema version: 20091012054719
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
#  income            :integer(4)
#  gender            :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  perishable_token  :string(255)
#  active            :boolean(1)
#  type              :string(255)     default("User")
#

class User < ActiveRecord::Base

  attr_accessor :old_password, :security_token

  acts_as_authentic do |authlogic|
    authlogic.check_passwords_against_database = true
    authlogic.crypto_provider = Authlogic::CryptoProviders::Sha1
    authlogic.perishable_token_valid_for = 1.month
    authlogic.disable_perishable_token_maintenance = true
  end
  
  validates_presence_of :name
  has_many :created_surveys, :foreign_key => "owner_id", :class_name => "Survey"
  
  has_one :wallet
  has_many :completions
  has_many :surveys, :through => :completions
  has_many :answers
  has_many :payments, :foreign_key => "owner_id", :class_name => "Payment"

  after_create :setup_user

  validate :password_change_security
  
  def age
    @age ||= birthdate.extend(Age)
  end

  def income
    @income ||= self[:income].to_s.extend(Income)
  end

  def complete_survey(survey)
    wallet.record_completed_survey(survey)
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
  
  def has_permission_for?(args)
    requested_item = args[:class].constantize.find(args[:object_id])
    requested_item.send(args[:attribute_id]).eql?(args[:current_user].id) ? true : false
  end
  
  private
  
  def setup_user
    reset_perishable_token!
    deliver_activation_mail
    create_wallet
  end
  
  def deliver_activation_mail
    UserMailer.deliver_activation_mail(self)
  end
  
  def deliver_reset_instructions_mail
    reset_perishable_token!
    UserMailer.deliver_reset_instructions_mail(self)
  end

  def create_wallet
    self.wallet = Wallet.create(:user => self) if self.wallet.nil?
  end
  
  def password_change_security
    if password
      unless new_record? or valid_perishable_token?(security_token) or old_password_valid?
        errors.add(:old_password, "is invalid")
      end
    end
  end
  
end

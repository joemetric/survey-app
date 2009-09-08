class User < ActiveRecord::Base

  attr_accessor :old_password

  acts_as_authentic do |authlogic|
    authlogic.check_passwords_against_database = true
    authlogic.crypto_provider = Authlogic::CryptoProviders::Sha1
    authlogic.perishable_token_valid_for = 1.month
    authlogic.disable_perishable_token_maintenance = true
  end
  
  validates_presence_of :name

  has_one :wallet
  has_many :completions
  has_many :surveys, :through => :completions
  has_many :answers

  after_create :setup_user

  validate :check_old_password
  
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
  
  private
  
  def setup_user
    deliver_activation_mail
    create_wallet
  end
  
  def deliver_activation_mail
    UserMailer.deliver_activation_mail(self)
  end
  
  def deliver_reset_instructions_mail
    UserMailer.deliver_reset_instructions_mail(self)
  end

  def create_wallet
    self.wallet = Wallet.create(:user => self) if self.wallet.nil?
  end
  
  # This is not cool.
  # Looking for a better way to do this: If it's a manual password change, require old password
  # if it's reset password or new profile, ignore this check
  def check_old_password
    if old_password
      errors.add(:old_password, "is invalid") unless valid_password?(old_password)
    end
  end
  
end

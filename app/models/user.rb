class User < ActiveRecord::Base
  acts_as_authentic do |authlogic|
    authlogic.crypto_provider = Authlogic::CryptoProviders::Sha1
    authlogic.perishable_token_valid_for = 1.month
  end

  has_one :wallet
  has_many :completions
  has_many :surveys, :through => :completions
  has_many :answers

  after_create :setup_user
  
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
  
  def reset_passwd
    reset_password!
    deliver_password_mail
  end
  
  private
  
  def setup_user
    deliver_activation_mail
    create_wallet
  end
  
  def deliver_activation_mail
    UserMailer.deliver_activation_mail(self)
  end
  
  def deliver_password_mail
    UserMailer.deliver_password_mail(self)
  end

  def create_wallet
    self.wallet = Wallet.create(:user => self) if self.wallet.nil?
  end
  
end

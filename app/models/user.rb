class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.disable_perishable_token_maintenance = true
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
  
  def active?
    perishable_token.blank?
  end
  
  private
  
  def setup_user
    deliver_activation_mail
    create_wallet
  end
  
  def deliver_activation_mail
    UserMailer.deliver_activation_mail(self)
  end

  def create_wallet
    self.wallet = Wallet.create(:user => self) if self.wallet.nil?
  end
  
end

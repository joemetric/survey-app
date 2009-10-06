class Survey < ActiveRecord::Base

  belongs_to :owner, :class_name => "User"
  
  has_many :questions
  has_many :restrictions
  has_many :completions
  has_many :users, :through => :completions
  has_one :payment #  This can be changed to has_many :payments if user can re-open the closed survey for which he has to pay again

  validates_presence_of :name, :owner_id
  validates_numericality_of :responses

  accepts_nested_attributes_for :questions, :restrictions
 
  named_scope :pending, { :conditions => { :publish_status => "pending" }}
  named_scope :by_time, :order => :created_at 
  named_scope :saved, { :conditions => { :publish_status => "saved" }}
  named_scope :by, lambda { |user| { :conditions => { :owner_id => user.id }} }
  
  include AASM
  concerned_with :payment_state_machine
  concerned_with :publish_state_machine
 
  def published?
    !published_at.blank?
  end
  
  def publish!
    published!
    update_attribute(:published_at, Time.now)
  end
  
  def reject!
    rejected!
    deliver_rejection_mail
  end

  def save_payment_details(params, response)
    pd = Payment.new # pd means payment_details
    pd.survey_id = id
    pd.token = params['token']
    pd.payer_id = params['PayerID']
    pd.transaction_id = response.params['transaction_id']
    pd.amount = 50 # This value will be as per the package selected
    pd.save
  end
  
  private
  
  def deliver_rejection_mail
    UserMailer.deliver_survey_rejection_mail(self)
  end
  
end

class Survey < ActiveRecord::Base

  belongs_to :owner, :class_name => "User"
  
  has_many :questions
  has_many :restrictions
  has_many :completions
  has_many :users, :through => :completions
  has_one :payment #  This can be changed to has_many :payments if user can re-open the closed survey for which he has to pay again

  validates_presence_of :name, :owner_id

  accepts_nested_attributes_for :questions, :restrictions
 
  named_scope :pending, { :conditions => ["published_at is null"] }
  named_scope :by_time, :order => :created_at 
  
  concerned_with :state_machine
 
  def published?
    !published_at.blank?
  end
  
  def publish!
    update_attribute(:published_at, Time.now)
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
  
end

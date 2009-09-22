class Survey < ActiveRecord::Base

  include AASM

  belongs_to :owner, :class_name => "User"
  
  has_many :questions
  has_many :restrictions
  has_many :completions
  has_many :users, :through => :completions

  accepts_nested_attributes_for :questions, :restrictions
  
  #  This can be changed to has_many :payments if user can re-open the closed survey for which he has to pay again
  has_one :payment

  validates_presence_of :name, :owner_id
 
  aasm_column :payment_status
  aasm_initial_state :pending
  
  aasm_state :pending
  aasm_state :authorized
  aasm_state :paid
  aasm_state :declined
  aasm_state :cancelled
  
  aasm_event :pending do
    transitions :to => :pending, :from => [:pending]
  end
  
  aasm_event :authorized do
    transitions :to => :authorized, :from => [:pending, :cancelled]
  end
  
  aasm_event :paid do
    transitions :to => :paid, :from => [:pending, :authorized, :cancelled]
  end

  aasm_event :declined do
    transitions :to => :declined, :from => [:authorized, :pending, :declined, :cancelled]
  end
  
  # We may not require this but still its better to keep this in order to differentiate between 
  # payment_status as declined(error in payment process/invalid account details)  
  # and cancelled (user proactively cancelled the payment)
  
  aasm_event :cancelled do 
    transitions :to => :cancelled, :from => [:pending, :declined, :authorized, :cancelled]
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

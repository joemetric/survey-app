class Survey < ActiveRecord::Base
  
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
end
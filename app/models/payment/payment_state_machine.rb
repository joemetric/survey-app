class Payment < ActiveRecord::Base
  
  aasm_column :status
  aasm_initial_state :incomplete
  
  aasm_state :incomplete
  aasm_state :authorized
  aasm_state :paid
  aasm_state :declined
  aasm_state :cancelled
  
  aasm_event :incomplete do
    transitions :to => :incomplete, :from => [:incomplete]
  end
  
  aasm_event :authorized do
    transitions :to => :authorized, :from => [:incomplete, :cancelled, :authorized]
  end
  
  aasm_event :paid do
    transitions :to => :paid, :from => [:incomplete, :declined, :authorized, :cancelled]
  end
  
  aasm_event :declined do
    transitions :to => :declined, :from => [:authorized, :incomplete, :declined, :cancelled]
  end
  
  # We may not require this but still its better to keep this in order to differentiate between 
  # payment_status as declined(error in payment process/invalid account details)  
  # and cancelled (user proactively cancelled the payment)
  
  aasm_event :cancelled do 
    transitions :to => :cancelled, :from => [:incomplete, :declined, :authorized, :cancelled]
  end
end
class Survey < ActiveRecord::Base

  aasm_column :publish_status
  aasm_initial_state :pending
  
  aasm_state :pending
  aasm_state :saved
  aasm_state :published
  aasm_state :rejected
  
  aasm_event :pending do
    transitions :to => :pending, :from => [ :pending, :saved ]
  end
  
  aasm_event :saved do
    transitions :to => :saved, :from => [ :pending ]
  end
  
  aasm_event :published do
    transitions :to => :published, :from => [ :pending, :saved ]
  end
  
  aasm_event :rejected do
    transitions :to => :rejected, :from => [ :pending, :saved ]
  end
    
end
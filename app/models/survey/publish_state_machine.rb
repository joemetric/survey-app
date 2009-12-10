class Survey < ActiveRecord::Base

  aasm_column :publish_status
  aasm_initial_state :pending
  
  aasm_state :pending
  aasm_state :saved
  aasm_state :published
  aasm_state :rejected
  aasm_state :finished
  aasm_state :expired
  
  aasm_event :pending do
    transitions :to => :pending, :from => [ :pending, :saved ]
  end
  
  aasm_event :saved do
    transitions :to => :saved, :from => [ :pending ]
  end
  
  aasm_event :published do
    transitions :to => :published, :from => [ :pending, :saved, :rejected ]
  end
  
  aasm_event :rejected do
    transitions :to => :rejected, :from => [ :published, :finished, :pending, :saved ]
  end
  
  aasm_event :finished do
    transitions :to => :finished, :from => [ :published ]
  end
    
  aasm_event :expired do
    transitions :to => :expired, :from => [ :published, :finished ]
  end  
          
end
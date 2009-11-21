class Reply < ActiveRecord::Base
  
  aasm_column :status
  aasm_initial_state :incomplete
  
  aasm_state :incomplete
  aasm_state :complete
  aasm_state :paid
  
  aasm_event :incomplete do
    transitions :to => :incomplete, :from => [:incomplete]
  end
  
  aasm_event :complete do
    transitions :to => :complete, :from => [:incomplete, :complete]
  end
  
  aasm_event :paid do
    transitions :to => :paid, :from => [:complete]
  end
 
end
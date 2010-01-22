class Reply < ActiveRecord::Base
  
  aasm_column :status
  aasm_initial_state :incomplete
  
  aasm_state :incomplete
  aasm_state :complete, :after => :set_completion_date
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
  
  def set_completion_date
    update_attribute(:completed_at, Time.now)
  end
 
end
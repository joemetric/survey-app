class Survey < ActiveRecord::Base

  aasm_column :publish_status
  aasm_initial_state :pending
  
  aasm_state :pending
  aasm_state :saved
  aasm_state :published, :after => :set_published_at
  aasm_state :rejected,  :after => :deliver_rejection_mail
  aasm_state :finished
  aasm_state :expired
  
  aasm_event :pending do
    transitions :to => :pending, :from => [ :pending, :saved ]
  end
  
  aasm_event :saved do
    transitions :to => :saved, :from => [ :pending ]
  end
  
  aasm_event :published do
    transitions :to => :published, :from => [ :pending, :rejected ]
  end
  
  aasm_event :rejected do
    transitions :to => :rejected, :from => [ :published, :pending ]
  end
  
  aasm_event :finished do
    transitions :to => :finished, :from => [ :published ]
  end
    
  aasm_event :expired do
    transitions :to => :expired, :from => [ :published, :finished ]
  end  
  
  def set_published_at
    update_attribute(:published_at, Time.now)
  end
          
end
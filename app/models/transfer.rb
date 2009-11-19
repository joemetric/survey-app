# == Schema Information
# Schema version: 20091110082101
#
# Table name: transfers
#
#  id            :integer(4)      not null, primary key
#  reply_id      :integer(4)
#  status        :string(100)     default("pending")
#  amount        :float
#  paypal_params :text
#  created_at    :datetime
#  updated_at    :datetime
#

class Transfer < ActiveRecord::Base
  
# This model will handle transfering of payout amount to users who completed 
# answering all the questions of Survey.
  
  named_scope :pending, { :conditions => { :status => "pending" } }
  named_scope :paid, { :conditions => { :status => "paid" } }
  
  include AASM
  aasm_column :status
  aasm_initial_state :pending
  
  aasm_state :pending
  aasm_state :complete
  aasm_state :failed
  
  aasm_event :pending do
    transitions :to => :pending, :from => [ :pending, :failed ]
  end
  
  aasm_event :complete do
    transitions :to => :complete, :from => [ :pending, :failed ]
  end
  
  aasm_event :failed do
    transitions :to => :failed, :from => [ :pending, :failed ]
  end
  
  serialize :paypal_params
  
  belongs_to :reply
  
  def survey
    reply.survey
  end
    
  def self.pending
    Reply.find(:all, :conditions => ['paid = ? AND created_at < ?', false, 1.week.ago])
  end
  
  def self.create_for(reply) 
    Transfer.create({:reply_id => reply.id, :amount => reply.total_payout})
  end
  
  def self.find_or_create_for(reply)
    reply.transfer || create_for(reply) 
  end
  
  def self.process(reply)
    transfer = find_or_create_for(reply)
    response = Payment.transfer(transfer.amount * 100, reply.user.email)
    transfer.paypal_params = response.params
    if response.success?
      transfer.complete!
      reply.update_attribute(:paid, true)
    else
      transfer.failed!
    end
    transfer.save
  end
 
end

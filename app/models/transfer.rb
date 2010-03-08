# == Schema Information
# Schema version: 20100308160716
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
  
  ['pending', 'complete', 'failed'].each do |s|
    define_method "#{s}?" do
      status == s
    end
  end
    
  def self.pending
    Reply.all(:conditions => ['status = ? AND created_at < ?', 'complete', 1.week.ago])
  end
  
  def self.create_for(reply) 
    Transfer.create({:reply_id => reply.id})
  end
  
  def self.find_or_create_for(reply)
    transfer = reply.transfer || create_for(reply)
    @donation_details = NonprofitOrgsEarning.find(:first, :conditions => ['survey_id = ? AND user_id =?', reply.survey_id, reply.user_id])
    if @donation_details
      transfer.amount = reply.total_payout - @donation_details.amount_donated_by_user
    else
      transfer.amount = reply.total_payout
    end
    transfer.save
    transfer
  end
  
  def self.process(reply)
    transfer = find_or_create_for(reply)
    response = Payment.transfer(transfer.amount * 100, reply.user.email)
    transfer.paypal_params = response.params
    if response.success?
      transfer.complete!
      reply.paid!
    else
      transfer.failed!
    end
    transfer.save
  end
  
  def survey
    reply.survey
  end  
 
end

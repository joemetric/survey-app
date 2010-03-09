# == Schema Information
# Schema version: 20100308160716
#
# Table name: payments
#
#  id             :integer(4)      not null, primary key
#  amount         :float
#  survey_id      :integer(4)
#  payer_id       :string(255)
#  token          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  transaction_id :string(255)
#  owner_id       :integer(4)
#  status         :string(255)     default("incomplete")
#

class Payment < ActiveRecord::Base
  
  ActiveRecord::Base.send(:extend, ConcernedWith)
  
  belongs_to :survey
  belongs_to :user, :foreign_key => "owner_id"
  
  include AASM
  concerned_with :payment_state_machine, :payment_processing
  
  named_scope :complete, :conditions => ['status = ?', 'paid']
  
  def paid? 
    status == 'paid'
  end
  
  def save_details(params, response)
    self.token = params['token']
    self.payer_id = params['payer_id']
    self.transaction_id = response.params['transaction_id']
    self.amount = survey.chargeable_amount
    self.save
  end
  
end

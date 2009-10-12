# == Schema Information
# Schema version: 20091012054719
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
#  status         :string(255)

class Payment < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :user, :foreign_key => "owner_id"
  
  include AASM
  concerned_with :payment_state_machine
  
end

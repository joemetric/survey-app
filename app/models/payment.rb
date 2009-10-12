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
#

class Payment < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :user, :foreign_key => "owner_id"
  
end

# == Schema Information
# Schema version: 20091110082101
#
# Table name: refunds
#
#  id                    :integer(4)      not null, primary key
#  survey_id             :integer(4)
#  owner_id              :integer(4)
#  amount                :float
#  refund_transaction_id :string(255)
#  paypal_response       :text
#  complete              :boolean(1)
#  error_code            :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class Refund < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :owner, :class_name => "User"

end

# == Schema Information
# Schema version: 20091008131247
#
# Table name: wallet_transactions
#
#  id          :integer(4)      not null, primary key
#  wallet_id   :integer(4)
#  amount      :float
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class WalletTransaction < ActiveRecord::Base
  belongs_to :wallet
  validates_presence_of :amount
  validates_numericality_of :amount
  validates_presence_of :description
end

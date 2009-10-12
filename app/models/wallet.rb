# == Schema Information
# Schema version: 20091012054719
#
# Table name: wallets
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Wallet < ActiveRecord::Base
  belongs_to :user 
  has_many :wallet_transactions
  
  def record_completed_survey( survey )
    wallet_transactions.create( {:amount => survey.amount, :description => survey.name} )
    
  end
  
  def record_withdrawal( amount )
    wallet_transactions.create( {:amount => (amount.abs * -1), :description => "Withdrawal"} )
  end
  
  def balance
    wallet_transactions.sum('amount').to_f.round(2)
  end
end

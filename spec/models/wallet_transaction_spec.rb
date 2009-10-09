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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WalletTransaction do
  # Replace this with your real tests.
  it "should be true" do
    true
  end
end

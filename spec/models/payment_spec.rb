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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Payment do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Payment.create!(@valid_attributes)
  end
end

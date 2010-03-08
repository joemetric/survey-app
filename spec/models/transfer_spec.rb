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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Transfer do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Transfer.create!(@valid_attributes)
  end
end

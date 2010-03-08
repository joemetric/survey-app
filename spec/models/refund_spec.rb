# == Schema Information
# Schema version: 20100308160716
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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Refund do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Refund.create!(@valid_attributes)
  end
end

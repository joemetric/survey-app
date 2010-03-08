# == Schema Information
# Schema version: 20100308160716
#
# Table name: survey_payouts
#
#  id         :integer(4)      not null, primary key
#  survey_id  :integer(4)
#  payout_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SurveyPayout do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    SurveyPayout.create!(@valid_attributes)
  end
end

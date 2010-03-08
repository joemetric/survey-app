# == Schema Information
# Schema version: 20100308160716
#
# Table name: survey_pricings
#
#  id                 :integer(4)      not null, primary key
#  survey_id          :integer(4)
#  package_pricing_id :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SurveyPricing do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    SurveyPricing.create!(@valid_attributes)
  end
end

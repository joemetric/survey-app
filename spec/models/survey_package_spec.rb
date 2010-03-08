# == Schema Information
# Schema version: 20100308160716
#
# Table name: survey_packages
#
#  id              :integer(4)      not null, primary key
#  survey_id       :integer(4)
#  name            :string(255)
#  code            :string(255)
#  base_cost       :float
#  total_responses :integer(4)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SurveyPackage do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    SurveyPackage.create!(@valid_attributes)
  end
end

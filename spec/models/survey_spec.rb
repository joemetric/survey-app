require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SurveyHelperMethods
  
  def valid_attributes
    { :name => "New Survey" }
  end
  
end

describe Survey do
  include SurveyHelperMethods
  fixtures :surveys
  
  before(:each) do
    @survey = Survey.new(valid_attributes)
  end
  
  context "Valid Attributes" do
    should_validate_presence_of :name
    should_validate_presence_of :owner_id
  end
  
end
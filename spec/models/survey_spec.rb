require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Survey do
  fixtures :surveys
  
  before(:each) do
    @survey = Survey.new(valid_attributes)
  end
  
  context "Valid Attributes" do
    should_validate_presence_of :name
    should_validate_presence_of :owner_id
    should_validate_presence_of :end_at
    
    it "End at should be posterior to current day" do
      @survey.valid?.should be(true)
      @survey.end_at = Time.now - 1.month
      @survey.valid?.should be(false)
      @survey.errors.collect { |attr, msg| "#{attr} #{msg}" }.should include("end_at is invalid")
    end
    
  end
  
  private
  
  def valid_attributes
    { :name => "New Survey",
      :owner_id => 1,
      :end_at => Time.now + 1.month
    }
  end
  
end
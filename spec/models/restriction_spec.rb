require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Restriction do

  before(:each) do
    @restriction = Restriction.new(valid_atrribute)
  end
  
  context "Valid Attributes" do
    should_validate_presence_of :kind
    should_validate_presence_of :value
  end

  private
  
  def valid_attributes
    { :kind => "gender",
      :value => "male" 
    }
  end
  
end
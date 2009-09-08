require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :users
  context "Valid Attributes" do 
    should_validate_uniqueness_of :email
    should_validate_uniqueness_of :login
    should_validate_presence_of :name
  end
  
  context "Creation" do
    it "should be inactive when created"
  end
end

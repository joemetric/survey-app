require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# spec spec/models/disability_spec.rb

describe Disability do
  before(:each) do
    @invalid_attributes = {:warning=>"Disabled !!!", :current_iphone_version =>"1.3", :older_iphone_version =>""}
    @valid_attributes = {:warning=>"Disabled !!!", :current_iphone_version =>"1.3", :older_iphone_version =>"1.0"}    
  end

  it "should save a new instance given valid attributes" do
    disability = Disability.new(@valid_attributes)
    disability.save.should == true
    disability.should == Disability.activated
  end
  
  it "should not save a new instance given valid attributes" do
    disability = Disability.new(@invalid_attributes)
    disability.save.should == false
  end
end

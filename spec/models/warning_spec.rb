# == Schema Information
# Schema version: 20100308160716
#
# Table name: warnings
#
#  id              :integer(4)      not null, primary key
#  iphone_version  :string(255)
#  warning         :text
#  warn_preference :string(255)
#  active          :boolean(1)      default(TRUE)
#  added_by        :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# spec spec/models/warning_spec.rb

describe Warning do
  before(:each) do
    @invalid_attributes = { :warn_preference => "always", :warning => "", :iphone_version =>" "}
    @valid_attributes = { :warn_preference => "always", :warning => "Warning !!", :iphone_version =>"1.0"}
  end

  it "should save a new instance given valid attributes" do
    warning = Warning.new(@valid_attributes)
    warning.save.should == true
    warning.should == Warning.activated
  end
  
  it "should not save a new instance given valid attributes" do
    warning = Warning.new(@invalid_attributes)
    warning.save.should == false
  end
end

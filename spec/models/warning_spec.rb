# == Schema Information
# Schema version: 20091127040223
#
# Table name: warnings
#
#  id             :integer(4)      not null, primary key
#  iphone_version :string(255)
#  warning        :text
#  warn           :string(255)
#  active         :boolean(1)      default(TRUE)
#  added_by       :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Warning do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Warning.create!(@valid_attributes)
  end
end

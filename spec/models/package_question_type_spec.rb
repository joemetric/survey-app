# == Schema Information
# Schema version: 20091012054719
#
# Table name: package_question_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  info       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PackageQuestionType do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    PackageQuestionType.create!(@valid_attributes)
  end
end

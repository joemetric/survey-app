# == Schema Information
# Schema version: 20100308160716
#
# Table name: package_pricings
#
#  id                       :integer(4)      not null, primary key
#  package_id               :integer(4)
#  package_question_type_id :integer(4)
#  total_questions          :integer(4)
#  standard_price           :float
#  normal_price             :float
#  created_at               :datetime
#  updated_at               :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PackagePricing do
#  before(:each) do
#    @valid_attributes = {
#      
#    }
#  end
#
#  it "should create a new instance given valid attributes" do
#    PackagePricing.create!(@valid_attributes)
#  end
end

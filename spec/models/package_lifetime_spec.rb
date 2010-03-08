# == Schema Information
# Schema version: 20100308160716
#
# Table name: package_lifetimes
#
#  id               :integer(4)      not null, primary key
#  package_id       :integer(4)
#  cancelled        :boolean(1)
#  total_uses       :integer(4)
#  valid_from       :date
#  valid_until      :date
#  validity_type_id :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PackageLifetime do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    PackageLifetime.create!(@valid_attributes)
  end
end

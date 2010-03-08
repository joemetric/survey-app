# == Schema Information
# Schema version: 20100308160716
#
# Table name: restrictions
#
#  id         :integer(4)      not null, primary key
#  survey_id  :integer(4)
#  value      :text
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Restriction do

#  before(:each) do
#    @restriction = Restriction.new(valid_atrribute)
#  end
#  
#  context "Valid Attributes" do
#    should_validate_presence_of :kind
#    should_validate_presence_of :value
#  end
#
#  private
#  
#  def valid_attributes
#    { :kind => "gender",
#      :value => "male" 
#    }
#  end
  
end

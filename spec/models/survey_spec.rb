# == Schema Information
# Schema version: 20100308160716
#
# Table name: surveys
#
#  id                            :integer(4)      not null, primary key
#  name                          :string(255)
#  created_at                    :datetime
#  updated_at                    :datetime
#  owner_id                      :integer(4)
#  payment_status                :string(255)
#  end_at                        :date
#  responses                     :integer(4)
#  published_at                  :datetime
#  publish_status                :string(255)     default("pending")
#  reject_reason                 :string(255)
#  package_id                    :integer(4)
#  chargeable_amount             :float
#  description                   :text
#  finished_at                   :datetime
#  reward_amount                 :float
#  physical_location_restriction :boolean(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Survey do
#  fixtures :surveys
#  
#  before(:each) do
#    @survey = Survey.new(valid_attributes)
#  end
#  
#  context "Valid Attributes" do
#    should_validate_presence_of :name
#    should_validate_presence_of :owner_id
#    should_validate_presence_of :end_at
#    should_validate_presence_of :responses
#    should_validate_numericality_of :responses
#    
#    it "End at should be posterior to current day" do
#      @survey.valid?.should be(true)
#      @survey.end_at = Time.now - 1.month
#      @survey.valid?.should be(false)
#      @survey.errors.collect { |attr, msg| "#{attr} #{msg}" }.should include("end_at is invalid")
#    end
#    
#  end
#  
#  private
#  
#  def valid_attributes
#    { :name => "New Survey",
#      :owner_id => 1,
#      :end_at => Time.now + 1.month,
#      :responses => 10
#    }
#  end
  
end

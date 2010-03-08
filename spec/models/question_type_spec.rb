# == Schema Information
# Schema version: 20100308160716
#
# Table name: question_types
#
#  id                       :integer(4)      not null, primary key
#  name                     :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  field_type               :string(255)
#  package_question_type_id :integer(4)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuestionType do
  fixtures :question_types
  
  before(:each) do
    @question_type = QuestionType.new(valid_attributes)
  end
  
  context "Valid Attributes" do 
    should_validate_presence_of :name
    should_validate_uniqueness_of :name
    
    it "should be one of valid field types available" do
      @question_type.save
      @question_type.field_type = "single_text_huge"
      @question_type.valid?.should be(false)
      @question_type.errors.collect { |attr, msg| attr }.should include("field_type")
    end
    
  end
  
  private
  
  def valid_attributes
    { :name => "Short Text Response",
      :field_type => "text_area"
    }
  end
  
end

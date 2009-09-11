require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module QuestionTypeHelperMethods

  def valid_attributes
    { :name => "Short Text Response" }
  end

end

describe QuestionType do
  include QuestionTypeHelperMethods
  fixtures :question_types
  
  before(:each) do
    @question_type = QuestionType.new(valid_attributes)
  end
  
  context "Valid Attributes" do 
    should_validate_presence_of :name
    should_validate_uniqueness_of :name
  end
  
end
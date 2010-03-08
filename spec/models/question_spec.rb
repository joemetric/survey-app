# == Schema Information
# Schema version: 20100308160716
#
# Table name: questions
#
#  id               :integer(4)      not null, primary key
#  created_at       :datetime
#  updated_at       :datetime
#  survey_id        :integer(4)
#  name             :string(255)
#  question_type_id :integer(4)
#  complement       :text
#  description      :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Question do
  fixtures :questions
  
  before(:each) do
    @question = Question.new(valid_attributes)
  end
  
  context "Valid Attributes" do
    should_validate_presence_of :name
    
    it "question name should be unique in a survey" do
      @question.save
      @new_question = Question.new({ :survey_id => @question.survey_id, :question_type_id => @question.question_type_id })
      @new_question.name = @question.name
      @new_question.valid?.should be(false)
      @new_question.errors.collect { |attr, msg| "#{attr} #{msg}" }.should include("name has already been taken")
    end
    
  end
  
  private
  
  def valid_attributes
    { :name => "Like this code?",
      :survey_id => 1,
      :question_type_id => 1 
    }
  end
  
end

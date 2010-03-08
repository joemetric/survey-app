# == Schema Information
# Schema version: 20100308160716
#
# Table name: answers
#
#  id                 :integer(4)      not null, primary key
#  reply_id           :integer(4)
#  question_id        :integer(4)
#  answer             :text
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer(4)
#  image_updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# spec spec/models/answer_spec.rb

describe Answer do
  
#  fixtures :questions, :replies
#  
#  it "should not be created without question_id, reply_id, answer" do
#    answer = answer_for(:question_id => nil, :reply_id => nil, :answer => nil)
#    answer.should be_invalid        
#  end
#  
#  it "should have a file for Photo Response questions" do
#    answer = answer_for_photo_response
#    answer.question.question_type.field_type.should == 'file_field'
#    answer.should be_invalid 
#    answer.errors.full_messages.should include('File is required')       
#  end
#  
#  it "should not be accepted for same question twice for same reply" do
#    answer = answer_for(:answer => 'Already answered this. Trying again', :reply_id => replies(:reply1_for_just_started_survey_1).id)
#    answer.should be_invalid
#    answer.errors.full_messages.should include('Question has already been taken') 
#  end
#  
#  it "should only accept JPG, GIF, PNG images for Photo response questions" do
#    answer = answer_for_photo_response(:image => image('valid_file.png'))
#    answer.should be_valid
#  end
#  
#  it "should not accpets image files other than JPG, GIF, PNG format for Photo response questions" do
#    answer = answer_for_photo_response(:image => image('invalid_file'))
#    answer.should be_invalid
#  end
#  
#  private
#  
#  def answer_for(options={})
#    Answer.new({ :question_id => questions(:just_started_1_q1).id }.merge(options))
#  end
#  
#  def answer_for_photo_response(options={})
#    parameters = { :question_id => questions(:just_started_1_q3).id, 
#                   :answer => 'Answer for Photo Response Question', 
#                   :reply_id => replies(:reply1_for_just_started_survey_1).id }
#    answer_for(parameters.merge(options))
#  end
#  
#  def image(name)
#    file_path = File.join(RAILS_ROOT, 'spec', 'images', name)
#    return File.new(file_path)
#  end
  
  
  
end

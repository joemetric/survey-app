# == Schema Information
# Schema version: 20100308160716
#
# Table name: replies
#
#  id           :integer(4)      not null, primary key
#  survey_id    :integer(4)
#  user_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  status       :string(255)     default("incomplete")
#  completed_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# spec spec/models/reply_spec.rb

describe Reply do
  
#  fixtures :users, :surveys
#
#  it "should not be created for invalid (expired) survey whose end date has passed" do
#    reply = create_reply_for(:survey_planA_5)
#    reply.should_not be_valid
#    reply.errors.full_messages.should include('You cannot take this survey. It has expired.')
#  end
#  
#  it "should not be created for survey who has recieved max responses" do
#    reply = create_reply_for(:completed_survey_1)
#    reply.should be_invalid
#    reply.errors.full_messages.should include('You cannot take this survey. It has expired.')
#  end
#  
#  it "should be created for published survey whose end date has not passed and reponses are left" do
#    reply = create_reply_for(:survey_planA_2)
#    reply.should be_valid
#  end
#  
#  it "should not created for same user twice" do
#    reply = invalid_reply_for(:completed_survey_1)
#    reply.should_not be_valid
#    reply.errors.full_messages.should include('User has already been taken')
#  end
#  
#  private
#  
#  def create_reply_for(survey)
#    reply = Reply.new({ :user_id => users(:iphone_user_3).id, :survey_id => surveys(survey).id})
#    reply.survey = surveys(survey)
#    reply
#  end
#  
#  def invalid_reply_for(survey)
#    reply = Reply.new({ :user_id => users(:iphone_user_1).id, :survey_id => surveys(survey).id})
#    reply.survey = surveys(survey)
#    reply
#  end
  
end

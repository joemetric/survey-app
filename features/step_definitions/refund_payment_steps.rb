#rake features FEATURE=features/refund_payments.feature

Given /^I have created a survey using the Default Package$/ do
  @user = Factory.create(:user, :login => 'owner', :email => 'owner@example.com' )
  @survey = Factory.create(:survey, :owner_id => @user.id)
end

Given /^I have used 4 Standard Questions, 3 Premium Questions, 2 Standard Demographic Restrictions, and 1 Premium Demographic Restrictions$/ do
  
end

When /^the survey expires with (.*) responses$/ do |responses|
  @survey.responses = responses.to_i
  @survey.end_at = "#{Date.today}"
  @survey.save
  
  responses.to_i.times do |count|
    @user = Factory.create(:user, :login => "aaron#{count}", :email => "aaron#{count}@example.com")
    @reply = @user.replies.create(:survey_id => @survey.id)
  end
end

Then /^the refund amount should be (.*) for the survey$/ do |amount|
  Refund.process(@survey).should == true
end


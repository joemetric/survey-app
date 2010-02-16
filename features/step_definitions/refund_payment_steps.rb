#rake features FEATURE=features/refund_payments.feature

Given /^I have created a survey using the Default Package$/ do
  @survey = Factory.create(:default_package_survey)
end

Given /^I have used 4 Standard Questions, 3 Premium Questions, 2 Standard Demographic Restrictions, and 1 Premium Demographic Restrictions$/ do
  
end

When /^the survey expires with (.*) responses$/ do |responses|
  @survey.responses = responses
  @survey.end_at = "#{Date.today}"
  
  responses.to_i.times do |count|
    @user = Factory.create(:user, :login => "aaron#{count}", :email => "aaron#{count}@example.com")
    @reply = @user.replies.create(:survey_id => @survey.id)
  end
end

Then /^the refund amount should be 0\.0 for the survey$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the refund amount should be 50\.0 for the survey$/ do
  pending # express the regexp above with the code you wish you had
end

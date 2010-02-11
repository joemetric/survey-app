# rake features FEATURE=features/payouts.feature

When /(.*) answered all the questions of Survey named (.*)/i do |login, survey|
  @user = Factory(:user, :login => login)
  @survey = Factory(:finished_survey, :name => survey)
end

When /(.*) did not answer all the questions of Survey named (.*)/i do |login, survey|
  @user = Factory(:user, :login => login)
  @survey = Factory(:finished_survey, :name => survey)
end

Then /reward of \$(.*) should be given to (.*) for completing (.*) survey/i do |amount, login, survey|
  completed_survey = Survey.find_by_name(survey)
  user = User.find_by_login(login)
  completed_survey.replies.by_user(user).first.total_payout.should == amount.to_f
end
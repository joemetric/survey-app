#rake features FEATURE=features/refund_payments.feature

When /^survey named (.*) will expire when it has received (.*) responses/ do |name, responses|
  @survey = Factory(:survey, :name => name, :responses => responses)
end

Then /refund amount should be \$(.*) for (.*) survey/i do |amount, name|
  survey = Survey.find_by_name(name)
  survey.refundable_amount.should == amount.to_f
end
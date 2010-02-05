#rake features FEATURE=features/refund_payments.feature

When /^survey named (.*) will expire who has received (.*) responses/ do |name, responses|
  @survey = Factory(:survey, :name => name, :responses => responses)
  survey = Survey.find_by_name(name)
  survey.should_not be_nil
  survey.replies.size.should == responses.to_i
end

Then /refund amount should be \$(.*) for (.*) survey/i do |amount, name|
  survey = Survey.find_by_name(name)
  survey.refundable_amount.should == amount.to_f
end
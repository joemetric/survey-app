# rake features FEATURE=features/survey_pricings.feature
# survey records are fetched from surveys.yml && questions.yml

Given /I am logged in as (.*)/i do |login|
  User.exists?(:login => login).should equal true
end

When /I create a Survey named (.*) which includes (.*) responses for (.*) Standard Questions, (.*) Premium Questions, (.*) Demographic Questions with Plan A/i do |name, responses, standard_questions, premium_questions, demographic_questions|
  Survey.exists?(:name => name).should equal true
end

Then /total price for survey (.*) will be \$(.*)/i do |name, cost|
  survey = Survey.find_by_name(name)
  survey.total_cost.should == cost.to_f
end

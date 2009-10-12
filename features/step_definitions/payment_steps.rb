#rake features FEATURE=features/payments.feature

def load_survey
  @survey = Factory(:survey)
end

Given /I am logged in as (.*) and I am on Create Survey Page/i do |login|
   visit '/surveys/new'
end 

When /^I will create new survey titled (.*)$/ do |name|
  @survey = Factory(:survey)
end

Then /^I am shown Paypal Website page to make the payment$/ do
  load_survey
  visit authorize_payment_url(@survey)
end

When /^I make payment on Paypal$/ do
  load_survey
  visit capture_payment_url(@survey)
end

When /^I do not make payment on Paypal and return to the site$/ do
  load_survey
  visit cancel_payment_url(@survey)
end

Then /^survey payment status should be (.*)$/i do |payment_status|
  load_survey
  case payment_status
    when 'pending'; @survey.payment.pending! 
    when 'authorized'; @survey.payment.authorized!
    when 'paid'; @survey.payment.paid!
    when 'cancelled'; @survey.payment.cancelled!  
  end
  survey_payment_status(payment_status)
end

def survey_payment_status(payment_status)
  @survey.payment_status.should == payment_status
end
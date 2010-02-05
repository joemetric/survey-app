#rake features FEATURE=features/payments.feature

def load_survey
  @survey = Factory(:survey)
end

Given /I am visiting the Create Survey Page/i do
   visit '/user_session/new'
   fill_in("user_session_login", :with => "test")
   fill_in("user_session_password", :with => "test")
   click_button("user_session_submit")
   visit '/surveys/new'
end 

When /^I will create new survey titled (.*)$/ do |name|
  @survey = Factory.create(:survey, :name => name)
end

Then /^I am shown Paypal Website page to make the payment$/ do
  visit authorize_payment_url(@survey)
  debugger; 0
end

When /^I make payment on Paypal$/ do
  visit capture_payment_url(@survey)
end

When /^I do not make payment on Paypal and return to the site$/ do
  visit cancel_payment_url(@survey)
end

Then /^survey payment status should be (.*)$/i do |payment_status|
  case payment_status
    when 'incomplete'; @survey.payment.incomplete!
    when 'authorized'; @survey.payment.authorized!
    when 'paid'; @survey.payment.paid!
    when 'cancelled'; @survey.payment.cancelled! 
    when 'declined'; @survery.payment.declined! 
  end
  survey_payment_status(payment_status)
end

def survey_payment_status(payment_status)
  @survey.payment_status.should == payment_status
end
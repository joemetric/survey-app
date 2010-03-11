class Payment < ActiveRecord::Base
   
  def self.capture(survey, params)
    transaction = ::GATEWAY.purchase(survey.cost_in_cents, :token => params['token'], :payer_id => params['PayerID'])
    survey.payment.paid!
    survey.save_payment_details(params, transaction)
  end
  
  def self.verify_token(token)
    ::GATEWAY.details_for(token)
  end
  
  def self.refund(survey, payment)
   ::GATEWAY.credit(
     survey.refundable_amount.cost_in_cents, 
     payment.transaction_id,
     {:note => "www.joemetric.com - Payment Refund for Survey #ID:#{survey.id} - #{survey.name}"}
   )
  end
  
  def self.transfer(amount, email)
    ::GATEWAY.transfer [amount, email], :subject => "JoeSurvey cash", :note => "Thank you for completing one or more surveys."
  end
  
end
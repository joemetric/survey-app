class PaypalProcessor
  
  # This is added to include class Array defined in application_controller.rb
  # Methods from application_controller.rb are not included when we run
  # ruby script/runner PaypalProcessor.execute
  require 'application_controller'
  
  def self.execute
     refund
     transfer
  end
  
  def self.refund
    Survey.expired_surveys.each do |survey|
      payment = survey.payment
      if payment.paid? && survey.refund_pending?
        verification = Payment.verify_token(payment.token)
        if verification.success?
          verification = Payment.refund(survey, payment)
          survey.refund_complete(verification) # REFUND complete
        else
          # Before refunding the payment amount, User has to accept the payment
          # and should complete IPR test from his Paypal account
          survey.refund_incomplete(verification) # REFUND cannot be done
        end
      end
    end
  end
  
  def self.transfer
    Transfer.pending.each {|r| Transfer.process(r) if r.complete?}
  end
  
end
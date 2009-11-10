class PaypalProcessorWorker < BackgrounDRb::MetaWorker
  set_worker_name :paypal_processor_worker
  
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def refund
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
  
  def transfer
    Transfer.pending.each {|r| Transfer.process(t) if r.complete?}
  end
  
  
end


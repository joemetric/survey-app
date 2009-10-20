class RefundWorker < BackgrounDRb::MetaWorker
  set_worker_name :refund_worker
  reload_on_schedule true
  
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def refund_payment
    Survey.expired_surveys.each do |survey|
      payment_info = survey.payment
      if payment_info.status == 'paid' && survey.refund_pending?
        response = GATEWAY.details_for(payment_info.token)
        if response.success?
          response = GATEWAY.credit(survey.refundable_amount, payment_info.transaction_id,
                      {:note => 'www.joemetric.com - Payment Refund for Survey #ID:#{survey.id} - #{survey.name}'})
          survey.refund_complete(response) # REFUND complete
        else
          # Before refunding the payment amount, User has to accept the payment
          # and should complete IPR test from his Paypal account
          survey.refund_incomplete(response) # REFUND cannot be done
        end
      end
    end
  end
  
end

class PaymentsController < ApplicationController
  
  before_filter :require_user
  before_filter :initialize_gateway

# NOTE - Amount passed to Paypal will be in CENTS
# TODO - Amount is considered as 500 CENTS for now which will be later according to the package selected
   
  def authorize
    response = @gateway.setup_purchase( 
      500,
      :order_id => "Survey:#{@survey.id} - #{@survey.name}",
      :return_url => capture_payment_url(@survey), 
      :cancel_return_url => cancel_payment_url(@survey), 
      :description => "Payment for Survey - #{@survey.name} (http://joemetric.com)"
    ) 
    if response.success? 
      @survey.authorized!
      redirect_to @gateway.redirect_url_for(response.params["token"])
    else 
     error_in_payment(@survey) 
    end
  end    

  def capture
    response = @gateway.details_for(params["token"]) 
    if response.success? 
      @survey.paid!
      response = @gateway.purchase(500, :token => params["token"], :payer_id => params["PayerID"])
      @survey.save_payment_details(params, response)
      flash[:notice] = "Thank You. You have successfully made the payment for the Your Survey."
      redirect_to survey_url(@survey) and return
    else
      error_in_payment(@survey) 
    end 
  end
  
  def refund
    payment_info = @survey.payment
    response = @gateway.details_for(payment_info.token)
    if response.success?
      response = @gateway.credit(400, 
                                 payment_info.transaction_id,
                                 {:note => 'Payment Refund for Survey #ID:#{@survey.id} - #{@survey.name}'})
      flash[:notice] = response.message
      redirect_to survey_url(@survey) and return
    else
      error_in_payment(@survey) 
    end
  end
  
  def cancel
    @survey.cancelled!
    flash[:notice] = "You have cancelled to make the payment for Survey: #{survey.name}"
    redirect_to survey_url(@survey)
  end

private
  
  def initialize_gateway
    @survey = Survey.find(params[:id])
    if RAILS_ENV == 'development'
      flash[:notice] = "#{@survey.name} is created successfully. (Payment Process is Skipped in Development Mode.)"
      redirect_to survey_url(@survey) and return
    end
    @gateway = GATEWAY
  end
  
  def error_in_payment(survey)
    survey.declined!
    flash[:error] = 'Payment Process could not be completed due to some unknown reasons.'
    redirect_to survey_url(survey)
  end
  
end
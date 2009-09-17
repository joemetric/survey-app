class PaymentsController < ApplicationController
  
  before_filter :require_user
   
  def authorize
    survey = Survey.find(params[:id])
    gateway = get_gateway 
    response = gateway.setup_purchase( 
      # This amount will be dynamic which will be as per the selected or default package as 
      # added by Administrator for Admin Panel
      50,
      :currency => "USD",
      :order_id => "Survey:#{survey.id} - #{survey.name}",
      :return_url => capture_payment_url(survey), 
      :cancel_return_url => cancel_payment_url(survey), 
      :description => "Payment for Survey - #{survey.name} (http://joemetric.com)"
    ) 
    if response.success? 
      survey.authorized!
      redirect_to gateway.redirect_url_for(response.params["token"])                 
    else 
     error_in_payment(survey) 
    end
  end    

  def capture
    gateway = get_gateway
    response = gateway.details_for(params["token"]) 
    survey = Survey.find(params[:id])
    if response.success? 
      survey.paid!
      survey.save_payment_details(params)
      response = gateway.purchase(params["amount"].to_i, :token => params["token"], :payer_id => params["PayerID"])
      flash[:notice] = "Thank You. You have successfully made the payment for the Your Survey."
      redirect_to survey_url(survey.id) and return
    else
      error_in_payment(survey) 
    end 
  end
  
  def cancel
    survey = Survey.find(params[:id])
    survey.cancelled!
    flash[:notice] = "You have cancelled to make the payment for Survey: #{survey.name}"
    redirect_to survey_url(survey)
  end

private
  
  def get_gateway()
     ActiveMerchant::Billing::Base.gateway(:paypal_express).new(PAYPAL_API_CREDENTIALS) 
  end  
  
  def error_in_payment(survey)
    survey.declined!
    flash[:error] = 'Payment Process could not be completed due to some unknown reasons.'
    redirect_to survey_url(survey)
  end
  
end

class PaymentsController < ApplicationController
  
  before_filter :require_user
  before_filter :initialize_gateway, :except => :index

# TODO for Piyush - Refactor - Move Paypal related methods in separate class file/module and 
# only use their return value in the methods defined below
  
  def index
    @payments = current_user.payments.complete.paginate(:all, :page => params[:page], :per_page => 10)
  end
   
  def authorize
    response = @gateway.setup_purchase( 
      @survey.cost_in_cents,
      :order_id => "Survey:#{@survey.id} - #{@survey.name}",
      :return_url => capture_payment_url(@survey), 
      :cancel_return_url => cancel_payment_url(@survey), 
      :description => "Payment for Survey - #{@survey.name} (http://joemetric.com)"
    ) 
    if response.success? 
      @survey.payment.authorized!
      redirect_to @gateway.redirect_url_for(response.params["token"])
    else 
     error_in_payment(response, @survey) 
    end
  end    

  def capture
    response = @gateway.details_for(params["token"]) 
    if response.success? 
      response = @gateway.purchase(@survey.cost_in_cents, :token => params["token"], :payer_id => params["PayerID"])
      @survey.payment.paid!
      @survey.save_payment_details(params, response)
      flash[:notice] = "Thank You. You have successfully made the payment for the Your Survey."
      redirect_to survey_url(@survey) and return
    else
      error_in_payment(response, @survey) 
    end 
  end
  
  def refund
    payment_info = @survey.payment
    response = @gateway.details_for(payment_info.token)
    if response.success?
      response = @gateway.credit(@survey.cost_in_cents, 
                                 payment_info.transaction_id,
                                 {:note => 'Payment Refund for Survey #ID:#{@survey.id} - #{@survey.name}'})
      flash[:notice] = response.message
      redirect_to survey_url(@survey) and return
    else
      error_in_payment(response, @survey) 
    end
  end
  
  def cancel
    @survey.payment.cancelled!
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
  
  def error_in_payment(response, survey)
    survey.payment.declined!
    flash[:error] = response.message
    redirect_to survey_url(survey)
  end
  
end

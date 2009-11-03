class PaymentsController < ApplicationController
  
  before_filter :require_user
  before_filter :initialize_gateway, :except => :index

# TODO for Piyush - Refactor - Move Paypal related methods in separate class file/module and 
# only use their return value in the methods defined below
  
  def index
    @payments = current_user.payments.complete.paginate(:all, :page => params[:page], :per_page => 10)
  end
   
  def authorize
    authorization = GATEWAY.setup_purchase( 
      @survey.cost_in_cents,
      :order_id => "Survey:#{@survey.id} - #{@survey.name}",
      :return_url => capture_payment_url(@survey), 
      :cancel_return_url => cancel_payment_url(@survey), 
      :description => "Payment for Survey - #{@survey.name} (http://joemetric.com)"
    ) 
    if authorization.success? 
      @survey.payment.authorized!
      redirect_to GATEWAY.redirect_url_for(authorization.params["token"])
    else 
     error_in_payment(authorization, @survey) 
    end
  end    

  def capture
    verification = Payment.verify_token(params['token'])
    if verification.success? 
      Payment.capture(@survey, params)
      flash[:notice] = "Thank You. You have successfully made the payment for Your Survey."
      redirect_to progress_surveys_path and return
    else
      error_in_payment(verification, @survey) 
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
  end
  
  def error_in_payment(response, survey)
    survey.payment.declined!
    flash[:error] = response.message
    redirect_to survey_url(survey)
  end
  
end

class PaymentsController < ApplicationController
  
  before_filter :require_user, :except => :refund
  before_filter :require_admin_or_reviewer, :only => :refund
  before_filter :initialize_gateway, :except => [:index, :refund]
  attr_accessor :token, :payerID
  
  def index
    @surveys = @current_user.created_surveys.paginate(:all, 
      :conditions => ['publish_status != ?', 'saved'], 
      :page => params[:page], 
      :per_page => 25)
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

  def confirm
    response = @gateway.purchase(@survey.cost_in_cents, :token => params[:token], :payer_id => params[:payer_id])

    if response.success?
      @survey.payment.paid!
      @survey.save_payment_details(params, response)
      session[:survey_id] = @survey.id
      flash[:notice] = "Thanks! Check back often to see the progress on your survey."
      redirect_to progress_surveys_url
    else
      flash[:notice] = response.message
      error_in_payment(response, @survey)
    end
  end

  def capture
    @token = params["token"]
    @payer_id = params["PayerID"]
    response = @gateway.details_for(params["token"]) 
    if !response.success? 
      error_in_payment(response, @survey) 
    end
  end
  
  def refund
    survey = Survey.find(params[:id])
    @response = Refund.process(survey)
    @refund = survey.refunds.last
    if @response
      flash[:notice] = "Refund of Amount #{@refund.amount} has been completed"
      ajax_redirect(conditional_redirect) and return
    end
  end
   
  def cancel
    @survey.payment.cancelled!
    flash[:notice] = "You have cancelled to make the payment for Survey: #{@survey.name}"
    redirect_to survey_url(@survey)
  end

private
  
  def initialize_gateway
    @survey = Survey.find(params[:id])
    #if RAILS_ENV == 'development'
     # flash[:notice] = "#{@survey.name} is created successfully. (Payment Process is Skipped in Development Mode.)"
      #redirect_to survey_url(@survey) and return
    #end
    @gateway = ::GATEWAY
  end
  
  def error_in_payment(response, survey)
    survey.payment.declined!
    flash[:error] = response.message
    redirect_to survey_url(survey)
  end
  
end

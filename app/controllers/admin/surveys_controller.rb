class Admin::SurveysController < ApplicationController
  
  before_filter :require_admin
  before_filter :find_object, :only => [ :show, :publish, :reject, :overview, :deny, :refund ]
  layout 'admin'
  
  def index
    @surveys = Survey.all
  end
  
  def show
  end
    
  def publish
    @survey.publish!
    redirect_to admin_surveys_path
  end
  
  def reject
    unless params[:survey][:other_reject_reason].blank?
      params[:survey].merge!(:reject_reason => params[:survey][:other_reject_reason])
    end
    if @survey.update_attributes(params[:survey])
      @survey.reject! if @survey.valid?
      ajax_redirect(admin_surveys_path)
    else
      show_error_messages(:survey)
    end
  end
  
  def overview
  end
  
  def deny
  end
  
  def refund
  end
  
  private
  
  def find_object
    @survey = Survey.find params[:id]
  end
  
end

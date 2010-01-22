class Admin::SurveysController < ApplicationController
  
  before_filter :require_admin_or_reviewer
  before_filter :find_object, :only => [ :show, :publish, :reject, :overview, :deny, :refund ]
  layout 'admin', :except => 'review'
  
  def index
    @surveys = Survey.for_approval
  end
  
  def review
    index
    render :template => 'admin/surveys/index', :layout => 'reviewer'
  end
  
  def show
  end
    
  def publish
    @survey.publish!
    redirect_to conditional_redirect
  end
  
  def reject
    unless params[:survey][:other_reject_reason].blank?
      params[:survey].merge!(:reject_reason => params[:survey][:other_reject_reason])
    end
    if @survey.update_attributes(params[:survey])
      @survey.rejected!
      ajax_redirect(conditional_redirect)
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

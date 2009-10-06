class Admin::SurveysController < ApplicationController
  
  before_filter :require_admin
  before_filter :find_object, :only => [ :show, :publish, :reject ]
  layout 'admin'
  
  def index
    @surveys = Survey.pending
  end
  
  def show
  end
    
  def publish
    @survey.publish!
    redirect_to pending_admin_surveys_path
  end
  
  def reject
    @survey.update_attributes(params[:survey])
    @survey.reject! if @survey.valid?
    redirect_to admin_surveys_path
  end
  
  private
  
  def find_object
    @survey = Survey.find params[:id]
  end
  
end

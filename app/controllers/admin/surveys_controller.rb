class Admin::SurveysController < ApplicationController
  before_filter :require_admin
  layout false
  
  def index
    @surveys = Survey.by_time
  end
  
  def pending
    @surveys = Survey.pending
  end
  
  def publish
    @survey = Survey.find params[:id]
    @survey.publish!
    redirect_to pending_admin_surveys_path
  end
  
end

class RepliesController < ResourceController::Base
  before_filter :require_user
  before_filter :find_survey
  
  def index
    @reply = Reply.find(:first, :conditions => { :user_id => @current_user.id, :survey_id => @survey.id })
  end
  
  private
  
  def find_survey
    @survey = Survey.find(params[:survey_id])
  end
  
end

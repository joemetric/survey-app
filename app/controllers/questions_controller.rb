class QuestionsController < ResourceController::Base
  belongs_to :survey
  before_filter :require_user
  
  index.wants.json { render :json => parent_object.questions  }
  show.wants.json { render :json => object }
  
  protected
  
  def parent_object
    Survey.find(params[:survey_id])
  end
  
end

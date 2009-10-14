class RepliesController < ApplicationController
  resource_controller  
  
  before_filter :require_user, :find_survey
  
  create.before do
    object.user = @current_user
    object.survey = @survey
  end    
  
  create do 
    wants.json { render :json => object, :header => 201 }
    failure do
      wants.json { rendon :json => object.errors.to_json, :header => 422 }
    end
  end
  
  private
  
  def find_survey
    @survey = Survey.find params[:survey_id]
  end
  
end

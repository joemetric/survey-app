class SurveysController < ResourceController::Base
  
  before_filter :require_user
  
  new_action.before do
    2.times { object.questions.build }
  end
  
  create.before do
    object.owner = current_user
  end
  
  def save
    @survey = Survey.new params[:survey]
    @survey.owner = current_user
    if @survey.valid?
      @survey.as_draft!
      redirect_to survey_path(@survey)
    else
      render :action => "new"
    end
  end
  
  create.wants.html { redirect_to authorize_payment_url(object.id) }
  show.wants.json { render :json => @object }
  
  private
  
  def collection
    @collection ||= end_of_association_chain.find(:all, 
                                                  :include => [:owner], 
                                                  :conditions => ['users.active = ?', true])
  end
  
end

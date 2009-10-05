class SurveysController < ResourceController::Base
  
  before_filter :require_user
    
  new_action.before do
    2.times { object.questions.build }
  end
  
  create.before do
    object.owner = current_user
  end
  
  def activate
    @survey = params[:id].blank? ? Survey.new(params[:survey]) : Survey.find(params[:id])
    @survey.owner = current_user if @survey.owner.blank?
    if @survey.valid?
      @survey.draft = false
      @survey.save
      redirect_to authorize_payment_url(@survey.id)
    else
      render :action => "new"
    end
  end
  
  show.wants.json { render :json => @object }
  
  private
  
  def collection
    @collection ||= end_of_association_chain.saved.by(@current_user)
  end
  
end

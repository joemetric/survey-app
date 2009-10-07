class SurveysController < ResourceController::Base
  
  before_filter :require_user
  before_filter :get_package, :only => [:new, :create]
    
  new_action.before do
    2.times { object.questions.build }
  end
  
  create.before do
    object.owner = current_user
  end
  
  create.after do
    object.saved!
  end
  
  def pricing
    @packages = Package.valid_packages.in_groups_of(2, false)
  end
  
  def activate
    @survey = params[:id].blank? ? Survey.new(params[:survey]) : Survey.find(params[:id])
    @survey.owner = current_user if @survey.owner.blank?
    if @survey.valid?
      @survey.save
      @survey.pending!
      redirect_to authorize_payment_url(@survey.id)
    else
      render :action => "new"
    end
  end
  
  def progress
    @surveys = @current_user.created_surveys.published
  end
  
  def finished
  end
  
  show.wants.json { render :json => @object }
  
  private
  
  def collection
    @collection ||= end_of_association_chain.saved.by(@current_user)
  end
  
  def get_package
    @package = Package.find_by_code(params[:package] ?  params[:package] : 'default')
  end
    
end

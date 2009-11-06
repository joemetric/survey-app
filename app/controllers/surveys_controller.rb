class SurveysController < ResourceController::Base

  before_filter :require_user
  before_filter :get_package, :only => [:new, :create, :activate]
   
  new_action.before do
    object.end_at = Time.now + 7.days
    2.times { object.questions.build }
  end

  create.before do
    object.owner = current_user
  end

  create.after do
    object.saved!
  end

  create.wants.html { redirect_to surveys_path }

  def pricing
    @packages = Package.valid_packages.in_groups_of(2, false)
  end

  def activate
    @survey = params[:id].blank? ? Survey.new(params[:survey]) : Survey.find(params[:id])
    @survey.owner = current_user if @survey.owner.blank?
    if @survey.valid?
      @survey.save
      @survey.pending!
      if RAILS_ENV == 'development' 
        redirect_to progress_surveys_path
      else
        redirect_to authorize_payment_url(@survey.id)
      end
    else
      render :action => "new"
    end
  end

  def progress
    @surveys = @current_user.created_surveys.in_progress
  end

  show do
    wants.json { render :json => @object.to_json(:methods => [ :total_payout ]) }
  end

  def index
    respond_to do |format|
      format.html do
        @surveys = Survey.saved.by(@current_user)
      end
      format.json do
        @surveys = Survey.published
        render :json => @surveys.to_json(:methods => [ :total_payout ]), :status => 200
      end
    end
  end
  
  def update_pricing
    render :json => Survey.pricing_details(params).to_json   
  end

  private

  def collection
    @collection ||= end_of_association_chain.saved.by(@current_user)
  end

  def get_package
    @package = Package.find_by_code(params[:package] ?  params[:package] : 'default')
  end

end

class SurveysController < ResourceController::Base

  before_filter :require_user
  before_filter :get_package, :only => [:new, :create, :activate]
  skip_before_filter :verify_authenticity_token, :only => [:progress_graph]
   
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
  
  def reward
    amount = Survey.find(params[:id]).replies.by_user(current_user).first.total_payout
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
        if @survey.no_payment_required?
          @survey.payment_without_paypal
          session[:survey_id] = @survey.id
          redirect_to progress_surveys_url
        else
          redirect_to authorize_payment_url(@survey.id)
        end
      end
    else
      render :action => "new"
    end
  end

  def progress
    @surveys = @current_user.created_surveys
    @survey_id, session[:survey_id] = session[:survey_id], nil  if session[:survey_id]
  end
  
  def reports
    @surveys = @current_user.created_surveys.published_and_finished
  end
  
  def copy
    @survey = @current_user.created_surveys.find(params[:id]) rescue nil
    unless @survey.nil?    
      ActiveRecord::Base.include_root_in_json = false
      @survey_json = @survey.to_json
      @questions = []
      @restrictions = []
      @copying_survey = true
      @survey.questions.each {|q| @questions << q.clone}
      @survey.restrictions.each {|r| @restrictions << r.clone}
    end
  end
  
  show do
    wants.json { render :json => @object.to_json(:user => current_user), :status => 200 }
  end

  def index
    respond_to do |format|
      format.html do
        @surveys = Survey.saved.by(@current_user)
      end
      format.json do
        current_user.device = params[:device].downcase
        @surveys = Survey.not_taken_by(current_user)
        render :json => @surveys.to_json(:user => current_user), :status => 200
      end
    end
  end
  
  def update_pricing
    render :json => Survey.pricing_details(params).to_json
  end
  
  def progress_graph
    @survey = @current_user.created_surveys.find(params[:id])
    @survey_ids = params[:ids].split(',')
  end
  
  def sort
    respond_to do |format|
      format.json do
        @surveys = Survey.list_for(current_user)
        render :json => @surveys.to_json(:user => current_user), :status => 200
      end
    end
  end

  private
  
  def object
    if ['show', 'edit', 'update'].include?(params[:action])
      object = @current_user.created_surveys.find(params[:id])
    else
      super      
    end
  end
  
  def collection
    @collection ||= end_of_association_chain.saved.by(@current_user)
  end

  def get_package
    @package = Package.find_by_code(params[:package] ?  params[:package] : 'default')
    @package = Package.default if @package.nil?
  end

end

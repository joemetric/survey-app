class SurveysController < ResourceController::Base

  before_filter :require_user
  before_filter :get_package, :only => [:new, :create, :activate]
  skip_before_filter :verify_authenticity_token, :only => [:progress_graph]

  new_action.before do
    object.end_at = Time.now + 7.days
    2.times { object.questions.build }
  end

  edit.before do
    @copying_survey = true
  end
  
  def create
    @survey = Survey.new(params[:survey])
    @survey.owner = current_user
    if @survey.save
      @survey.saved!
      ajax_redirect(surveys_path)
    else
      show_error_messages(:survey)
    end
  end

  def update
    @survey = @current_user.created_surveys.find(params[:survey][:id])
    @survey.deleted_questions = deleted_questions
    if @survey.update_attributes(params[:survey])
      ajax_redirect(surveys_path)
    else
      show_error_messages(:survey)
    end
  end

  create.wants.html { redirect_to surveys_path }

  def pricing
    @packages = Package.valid_packages.in_groups_of(2, false)
  end

  def reward
    amount = Survey.find(params[:id]).replies.by_user(current_user).first.total_payout
  end

  def activate
    @survey = params[:survey][:id].blank? ? Survey.new(params[:survey]) : @current_user.created_surveys.find(params[:survey][:id])
    @survey.owner = current_user if @survey.owner.blank?
    @survey.deleted_questions = deleted_questions unless @survey.new_record?
    if @survey.valid?
      @survey.save
      @survey.pending!
      #if RAILS_ENV == 'development'
       # ajax_redirect(progress_surveys_path)
      #else
        if @survey.no_payment_required?
          @survey.payment_without_paypal
          session[:survey_id] = @survey.id
          ajax_redirect(progress_surveys_path)
        else
          ajax_redirect(authorize_payment_path(@survey))
        end
      #end
    else
      show_error_messages(:survey)
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
      @questions = []
      @restrictions = []
      @copying_survey = true
      @survey.questions.each {|q| @questions << q.clone}
      @survey.restrictions.each {|r| @restrictions << r.clone}
      ActiveRecord::Base.include_root_in_json = true      
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
        if params["latitude"] && params["longitude"]
          @surveys = Survey.list_geographical_surveys_for(current_user, params["latitude"], params["longitude"])
        else
          @surveys = Survey.list_for(current_user)
        end
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

  def apply_discount_code
    @package = Package.find_by_code(params[:code]) rescue nil
    alert_message('Invalid Promotion Code. Please check and Try again.') if @package.nil?
  end
  
  def gMaps
    render :layout => false
  end
  
  private

  def object
    if ['show', 'edit'].include?(params[:action])
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

  def question_ids
    return [] if params[:survey][:questions_attributes].nil?
    returning ids = [] do 
      params[:survey][:questions_attributes].each {|question|
        ids << question['id'].to_i if question.key? :id
      }
    end
  end
  
  def deleted_questions
    question_ids.empty? ? @survey.question_ids : @survey.question_ids - question_ids 
  end

end

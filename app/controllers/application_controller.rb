class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  helper_method :current_user_session, :current_user, :current_admin_session, :current_admin, :current_reviewer,
                :convert_date_format
  filter_parameter_logging :password, :password_confirmation

  ActiveRecord::Base.send(:extend, ConcernedWith)

  def rescue_action_in_public_without_hoptoad(exception)
    case exception
    when ActiveRecord::RecordNotFound
      respond_to do |format|
        format.json { render :json => {"base" => "The item you were looking for doesn't exist."}, :header => 404 }
        format.html { render :file => "#{RAILS_ROOT}/public/404.html", :header => 404 }
      end
    when NoMethodError
      respond_to do |format|
        format.json { render :json => {"base" => "We're sorry, but something went wrong.\nWe've been notified about this issue and we'll take a look at it shortly."}, :header => 500 }
        format.html { render :file => "#{RAILS_ROOT}/public/500.html", :header => 500 }
      end
    else
      respond_to do |format|
        format.json { render :json => {"base" => "We're sorry, but something went wrong.\nWe've been notified about this issue and we'll take a look at it shortly."}, :header => 500 }
        format.html { render :text => "#{RAILS_ROOT}/public/500.html", :header => 500 }
      end
    end
  end

  private

  def current_admin_session
    return @current_admin_session if defined?(@current_admin_session)
    @current_admin_session = AdminSession.find
  end

  def current_admin
    return @current_admin if defined?(@current_admin)
    @current_admin = current_admin_session && current_admin_session.record
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_reviewer
    current_user if current_user.try(:is_reviewer?)
  end

  def current_consumer
    current_user if current_user.try(:is_consumer?)
  end

  def require_user
    #TODO Temp Fix - Use require_user_or_consumer instead
    unless (current_user.try(:is_user?) || current_user.try(:is_consumer?))
      redirect_to new_user_session_url
      return false
    end
  end

  # TODO - Check which sections are accessed by User and Consumer and apply this filter
  def require_user_or_consumer
    unless (current_user || current_consumer)
      redirect_to new_user_session_url
    end
  end

  def require_admin
    unless current_admin
      redirect_to new_admin_admin_session_url
    end
  end

  def require_reviewer
    unless current_user.try(:is_reviewer?)
      redirect_to new_user_session_url
      return false
    end
  end

  def require_admin_or_reviewer
    unless (current_admin || current_user.try(:is_reviewer?))
      redirect_to new_admin_admin_session_url
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def ajax_redirect(redirect_url)
    render :update do |page|
      page.redirect_to redirect_url
    end
  end

  def replace_html(div, content)
    render :update do |page|
      page.replace_html div, content
    end
  end

  def show_error_messages(item, options={})
    target_div = options.empty? ? 'errors' : options[:div]
    render :update do |page|
      page.replace_html target_div, error_messages_for(item)
      page << "$('##{target_div}').scrollTo(500);"
    end
  end

  def conditional_redirect
    session[:reviewer] ? review_admin_surveys_path : admin_surveys_path
  end

  def alert_message(message)
    render :update do |page|
      page.alert(message)
    end
  end

  def correct_date(date)
    date.gsub('/', '-').split('-').reverse.join('-')
  end

  def convert_date_format(date)
    date.to_s.gsub('-', '/').split('/').reverse.join('/') unless date.nil?
  end

end

class String

  def plural_form(count, add_text='');
     "#{count || 0} " + add_text + ((count == 1 || count == '1') ? self[0..length-2] : self)
  end

  def skip_info
    gsub(/[(].*[)]/, '')
  end

  def to_decimal
    remove_dollar_sym
  end

  def remove_dollar_sym
    gsub!('$', '').to_f
  end

  def nil_or_empty?
    empty?
  end

  def titleize
    eql?('martial_status') ? 'Martial Status' : super
  end

end

class Float

  def us_dollar
    Money.us_dollar(self * 100).format
  end

  def to_decimal
    us_dollar.remove_dollar_sym
  end

end

class Fixnum

  def us_dollar
    to_f.us_dollar
  end

  def less_than(number)
    self < number
  end

end

class Array

  Survey::QUESTION_TYPES.each_pair { |key, value|

    define_method("total_#{key}") do
      package_question_type_ids = []
      self.each { |hash|
        hash['package_question_type_id'] = QuestionType::PackageQuestionTypes[hash['question_type_id']]
        package_question_type_ids <<  hash.values_at('package_question_type_id')
      }
      package_question_type_ids.flatten.count {|x| x == value}
    end

    define_method(key.singularize) do
      select {|p| p.package_question_type_id == value}.compact.first
    end
  }

  def attribute_values(attr)
    collect {|a| a.send(attr)}
  end

  def to_array # Return array of answers for each question
    returning values = [] do
      self.each {|a| values << (a.question_type_id.eql?(3) ? a.image_url : a.answer)}
    end
  end

  def values_of(key)
    returning keys = [] do
      self.each {|a| keys << a[key]}
    end
  end

  def count(&action)
    begin
      count = 0
      self.each { |x| count = count + 1 if action.call(x) }
      return count
    rescue
      return 0
    end
  end

  def to_range(number, step_by)
    returning elements = [] do
      number.step(self.size, step_by) {|x| elements << x}
    end
  end

  def to_time_range(step_by, step_decreement=1)
    time_range = {}
    time_lap = Time.now.utc
    self.each_with_index { |e, i|
      time_increement = time_lap - step_decreement.send(step_by)
      time_range[e] = {:start => time_increement, :end => time_lap}
      time_lap = time_increement + 1.seconds
    }
    time_range.sort
  end

  def ids
    attribute_values(:id)
  end

  def elements
    collect {|x| x[0]}.compact
  end

  def nil_or_empty?
    empty?
  end

end

class NilClass

  ['to_date', 'us_dollar', 'to_decimal', 'strftime', 'downcase', 'titleize'].each do |name|
    define_method name do
      ''
    end
  end

  def nil_or_empty?
    true
  end

  def values_of(key)
    []
  end

end

class Hash

  def elements
    keys.sort
  end

  def values_of(key)
    returning value_elements = [] do
      self.each_pair { |key, value|
        value_elements << value['value']
      }
    end
  end

end

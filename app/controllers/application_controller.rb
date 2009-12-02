class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  helper_method :current_user_session, :current_user, :current_admin_session, :current_admin, :convert_date_format
  filter_parameter_logging :password, :password_confirmation

  ActiveRecord::Base.send(:extend, ConcernedWith)

  def rescue_action_in_public(exception)
    case exception
    when ActiveRecord::RecordNotFound
      respond_to do |format|
        format.json { render :json => "Object Not Found", :header => 404 }
        format.html { render :file => "#{RAILS_ROOT}/public/404.html", :header => 404 }
      end
    when NoMethodError
      respond_to do |format|
        format.json { render :json => "No Method Found", :header => 500 }
        format.html { render :file => "#{RAILS_ROOT}/public/500.html", :header => 500 }
      end
    else
      respond_to do |format|
        format.json { render :json => "Not Identified Error", :header => 500 }
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

  def require_user
    unless current_user
      redirect_to new_user_session_url
      return false
    end
  end
  
  def require_admin
    unless current_admin
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
    render :update do |page|
      page.replace_html options.empty? ? 'errors' : options[:div], error_messages_for(item)
    end
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

end

class Float

  def us_dollar
    Money.us_dollar(self * 100).format
  end

  def to_decimal
    us_dollar.remove_dollar_sym
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
  
  def count(&action)
    count = 0
    self.each { |x| count = count + 1 if action.call(x) }
    return count
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

end

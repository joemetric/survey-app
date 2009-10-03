class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  helper_method :current_user_session, :current_user, :current_admin_session, :current_admin
  filter_parameter_logging :password, :password_confirmation
  
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
      flash[:notice] = "Please log in first and we will send you right along ;)"
      redirect_to new_user_session_url
      return false
    end
  end
  
  def require_admin
    unless current_admin
      flash[:notice] = "Please log in first and we will send you right along ;)"
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
      page.replace_html 'errors', error_messages_for(item, options)
    end
  end
  
  def alert_message(message)
    render :update do |page|
      page.alert(message)
    end
  end
  

end

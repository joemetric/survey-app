module AdminHelper
  
  def reviewer_login_logout
    user_login_logout
  end
  
  def admin_login_logout
    current_admin ? render_admin_signout : render_admin_login
  end
  
  def render_admin_login
    link_to("Login", new_admin_admin_session_path)
  end
  
  def render_admin_signout
    link_to("Logout", admin_admin_session_path, :method => :delete)
  end
  
  def reject_options
    ["Privacy Violation", "Offensive Content"]
  end
  
end

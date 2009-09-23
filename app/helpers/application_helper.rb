module ApplicationHelper
  
  def render_notice
    content_tag(:div, flash[:notice], :class => "notice") if flash[:notice]
  end
  
  def question_type_options
    QuestionType.all.collect { |qt| [qt.name, qt.id] }
  end
  
  def demographic_restrictions_options
    Restriction::Kinds.collect { |kind| [kind.to_s.titleize, kind] }
  end
  
  def gender_options
    Gender::Values.collect { |kind| [kind.to_s.titleize, kind] }
  end
  
  def random_string(maximum_size = 6)
    (0...maximum_size).map{ ('a'..'z').to_a[rand(26)] }.join  
  end
  
  def render_profile_and_signout
    link_to("Hi #{content_tag(:font, @current_user.name, :color => "#000")}", user_path(@current_user)) + " | " + link_to("Logout", user_session_path, :method => :delete)
  end
  
  def render_signin_and_login
    link_to("Login", new_user_session_path) + " | " + link_to("Sign in", new_user_path)
  end
  
  
end

module ApplicationHelper
  
  def render_notice
    content_tag(:div, flash[:notice], :class => "notice") if flash[:notice]
  end
  
  def question_type_options
    QuestionType.all.collect { |qt| [qt.name, qt.id] }
  end
  
  def select_integer(limit=50)
    (1..limit).map {|i| [i, i]}
  end
  
  def demographic_restrictions_options
    Restriction::Kinds.collect { |kind| [kind.to_s.titleize, kind] }
  end
  
  def gender_options
    Gender::Values.collect { |kind| [kind.to_s.titleize, kind] }
  end
  
  def income_options
    User::Incomes.sort_by { |id, label| id }.collect { |id, label| [label, id] }
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
  
  def render_admin_login
    link_to("Login", new_admin_admin_session_path)
  end
  
  def render_admin_signout
    link_to("Logout", admin_admin_session_path, :method => :delete)
  end
 
  def menu_selected?(actions)
    actions.include?("#{params[:controller]}_#{params[:action]}") ? "selected" : "item"
  end
  
  def tab_selected?(actions)
    actions.include?("#{params[:controller]}_#{params[:action]}") ? "selected" : "item"
  end
  
  def current_tab_is?(tab_name)
    @tab == tab_name ? 'selected' : 'item'
  end
  
  def percent_of(ammount, total)
    (total == 0) ? 0 : ((ammount * 100 ) / total)
  end
  
  def loader_image
    content_tag(:div, image_tag('wait.gif'), :id => 'wait')
  end
  
end

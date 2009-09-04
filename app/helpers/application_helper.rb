# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def render_notice
    content_tag(:div, flash[:notice], :class => "notice") if flash[:notice]
  end
  
end

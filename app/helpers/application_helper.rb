module ApplicationHelper
  
  def render_notice
    content_tag(:div, flash[:notice], :class => "notice") if flash[:notice]
  end
  
  def question_type_options
    QuestionType.all.collect { |qt| [qt.name, qt.id] }
  end
  
  def random_string(maximum_size = 6)
    (0...maximum_size).map{ ('a'..'z').to_a[rand(26)] }.join  
  end
  
  
end

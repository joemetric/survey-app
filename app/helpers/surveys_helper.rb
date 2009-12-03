module SurveysHelper

  def link_to_survey(surveys)
    survey_ids = surveys.collect{|s| s.id}
    links = ''
    surveys.each do |s| 
      li_content = link_to_remote s.name, :url => progress_graph_survey_path(s.id, :ids => survey_ids.join(',')), :method => :get
      li_content += content_tag(:span, '', :id => "graph_#{s.id}")
      links += content_tag(:li, li_content, :id => "name_#{s.id}")
    end
    return links 
  end
  
end

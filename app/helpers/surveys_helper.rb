module SurveysHelper

  def link_to_surveys(surveys)
    survey_ids = surveys.collect{|s| s.id}
    links = ''
    surveys.each do |s| 
      li_content = link_to_remote s.name_with_status, :url => progress_graph_survey_path(s.id, :ids => survey_ids.join(',')), :method => :get
      li_content += content_tag(:span, '', :id => "graph_#{s.id}")
      links += content_tag(:li, li_content, :id => "name_#{s.id}")
    end
    return links 
  end
  
  def survey_link(survey)
    link_to survey.name, ( ( survey.completed? ) ? report_path(survey) : survey_path(survey)  )
  end
  
  def published_at(survey)
    survey.pending? ? 'Pending' : survey.published_at.to_date
  end
  
  def completed_at(survey)
    survey.published? ? 'In Progress' : (survey.rejected? ? 'Rejected' : survey.finished_at.to_date)
  end
  
  def survey_amount(survey)
    return unless survey.try(:payment)
    amount = survey.payment.amount.us_dollar
    survey.rejected? ? "-#{amount}" : amount
  end
  
  def select_options(options)
    options.sort_by { |key, vlu| key}.collect { |id, label| [label, id] }
  end
  
end

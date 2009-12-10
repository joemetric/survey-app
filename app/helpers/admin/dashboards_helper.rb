module Admin::DashboardsHelper
  
  def observe_demographic_field(field_id)
    observe_field field_id, :url => demographic_distribution_dashboard_path, :with => "'segment_by=' + $('#segment_by option:selected').val() + '&filter_by=' + $('#filter_by option:selected').val()"
  end
  
  def select_segment_by(options=[], selected='Nothing')
    options = options.compact.collect { |kind| [kind.to_s.titleize, kind] } unless options.empty?
    %Q{
      #{select_tag 'segment_by', options_for_select(['Nothing'] + options, selected.to_sym), :class => 'select_bg'}
      #{observe_demographic_field('segment_by')}
    }
  end
  
  def survey_distribution_list
    dashboard_select_list({:id => 'survey', :default => 'Select', :options => Survey::SurveyOptions})
  end
  
  def survey_distribution_range
    distribution_list('survey_range')
  end
  
  def finance_distribution
    dashboard_select_list({:id => 'finance', :default => 'Select', :options => Survey::FinanceOptions})
  end
  
  def finance_distribution_range
    distribution_list('finance_range')
  end
  
  def distribution_list(element_id)
    dashboard_select_list({:id => element_id, :default => 'Nothing', :options => Survey::Distribution})
  end
    
  def dashboard_select_list(args)
    select_tag args[:id], options_for_select([args[:default]] + args[:options].collect { |id, label| [label, id] }), :class => 'select_bg'
  end
  
  def survey_distribution_results(args)
    table_rows(args.merge!({:distribution_for => 'Survey'}))
  end
  
  def financial_distribution_results(args)
    table_rows(args.merge!({:distribution_for => 'Finance'}))
  end
 
  def table_rows(args)
    if defined?(@column)
      args.merge!({:column => @column})
    else
      args.merge!({:column => args[:class] == 'Survey' ? :finished_at : (args[:class] == 'Reply' ? :completed_at : :created_at)})
    end
    table_rows = ''
    if args[:records].blank?
      if args[:distribution_for] == 'Finance'
        count = 0.us_dollar
      else
        count = [:finished_at, :created_at].include?(args[:column]) ?  0 : 0.us_dollar
      end
    end
    args[:ranges].each { |obj|
      row_data = content_tag(:td, obj[0])
      unless args[:records].blank?
        if args[:distribution_for] == 'Survey'
          count = args[:records].to_a.count {|r| between_duration?(r.send(args[:column]), obj[1])}  
        else
          if args[:column] == :created_at
            amount = args[:records].collect {|r| r.amount if r.try(:created_at) && between_duration?(r.created_at, obj[1])}.compact
            count = amount.sum.us_dollar
          else
            finished_surveys = args[:records].collect {|r| r if between_duration?(r.finished_at, obj[1])}.compact
            margin_count = finished_surveys.collect {|r| r.gross_margin }
            total = margin_count.sum / finished_surveys.size rescue 0
            count = number_to_percentage(total, :precision => 0)
          end
        end
      end
      row_data += content_tag(:td, count)
      table_rows += content_tag(:tr, row_data)
    }
    table_rows
  end
  
  def between_duration?(time, range)
    time.between?(range[:start], range[:end])
  end
  
end

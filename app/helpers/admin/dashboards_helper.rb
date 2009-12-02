module Admin::DashboardsHelper
  
  def observe_demographic_field(field_id)
    observe_field field_id, :url => demographic_distribution_dashboard_path, :with => "'segment_by=' + $('#segment_by option:selected').val() + '&filter_by=' + $('#filter_by option:selected').val()"
  end
  
  def select_segment_by(options=[])
    options = options.compact.collect { |kind| [kind.to_s.titleize, kind] } unless options.empty?
    %Q{
      #{select_tag 'segment_by', options_for_select(['Nothing'] + options), :class => 'select_bg'}
      #{observe_demographic_field('segment_by')}
    }
  end
  
  def survey_distribution
  end
  
  def survey_distribution_range
    distribution_list('survey_range')
  end
  
  def finance_distribution
  end
  
  def finance_distribution_range
    distribution_list('finance_range')
  end
  
  def distribution_list(element_id)
    select_tag element_id, options_for_select(['Nothing'] + Survey::Distribution.sort_by { |id, label| id }.collect { |id, label| [label, id] }), :class => 'select_bg'
  end
 
  def table_rows_for(records, ranges)
    table_rows = ''
    ranges.each { |obj|
     row_data = content_tag(:td, obj[0])
     row_data += content_tag(:td, records.to_a.count {|r| r.finished_at.between?(obj[1][:start], obj[1][:end])} )
     table_rows += content_tag(:tr, row_data)
    }
    table_rows
  end
end

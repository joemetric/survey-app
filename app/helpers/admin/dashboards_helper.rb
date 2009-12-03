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
    select_tag 'finance', options_for_select(['Select'] + Survey::FinanceOptions.collect { |id, label| [label, id] }), :class => 'select_bg'
  end
  
  def finance_distribution_range
    distribution_list('finance_range')
  end
  
  def distribution_list(element_id)
    select_tag element_id, options_for_select(['Nothing'] + Survey::Distribution.collect { |id, label| [label, id] }), :class => 'select_bg'
  end
  
  def survey_distribution_results(args)
    table_rows(args.merge!({:column => :finished_at}))
  end
  
  def financial_distribution_results(args)
    table_rows(args.merge!({:column => :created_at}))
  end
 
  def table_rows(args)
    table_rows = ''
    count = args[:column] == :finished_at ? 0 : 0.us_dollar if args[:records].blank?
    args[:ranges].each { |obj|
     row_data = content_tag(:td, obj[0])
     unless args[:records].blank?
       if args[:column] == :finished_at
         count = args[:records].to_a.count {|r| r.finished_at.between?(obj[1][:start], obj[1][:end])}
       elsif args[:column] == :created_at
         amount = args[:records].collect {|r| r.amount if r.try(:created_at) && r.created_at.between?(obj[1][:start], obj[1][:end])}.compact
         count = amount.sum.us_dollar
       end
     end
     row_data += content_tag(:td, count)
     table_rows += content_tag(:tr, row_data)
    }
    table_rows
  end
  
end

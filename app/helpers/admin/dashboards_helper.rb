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
  
  def nonprofit_org_time_range
    time_range_list('time_range')
  end
  
  def nonprofit_orgs_results(args)
    table_organization_earning_rows(args)
  end
  
  def time_range_list(element_id)
    dashboard_select_list({:id => element_id, :default => 'Select', :options => NonprofitOrgsEarning::TimeRange})
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
  
  def table_organization_earning_rows(args)
    table_rows = ''
    row_data = ''
    @quater_start = Date.today.beginning_of_quarter - 2.days
    @quarter_start_arr = @quater_start.to_s.split('-')
    @last_quarter_stat = Date.new(@quarter_start_arr[0].to_i, @quarter_start_arr[1].to_i, @quarter_start_arr[2].to_i).beginning_of_quarter.to_datetime
    @last_quarter_start = @last_quarter_stat - 2.days
    @last_quarter_start_arr = @last_quarter_start.to_s.split('-')
    @last_last_quarter_stat = Date.new(@last_quarter_start_arr[0].to_i, @last_quarter_start_arr[1].to_i, @last_quarter_start_arr[2].to_i).beginning_of_quarter.to_datetime
    
    if args[:ranges] == "today"
      start_from = Time.now.beginning_of_day 
      end_at = Time.now.end_of_day
      chnaged_start_from = 1.days.ago.beginning_of_day
      changed_end_at = 1.days.ago.end_of_day
    elsif args[:ranges] == "this_week"
      start_from = Time.now.beginning_of_week 
      end_at = Time.now.end_of_week
      chnaged_start_from = 1.week.ago.beginning_of_week
      changed_end_at = 1.week.ago.end_of_week
    elsif args[:ranges] == "last_week"
      start_from = 1.week.ago.beginning_of_week
      end_at = 1.week.ago.end_of_week
      chnaged_start_from = 2.weeks.ago.beginning_of_week
      changed_end_at = 2.weeks.ago.end_of_week
    elsif args[:ranges] == "this_month"
      start_from = Time.now.beginning_of_month 
      end_at = Time.now.end_of_month
      chnaged_start_from = Time.now.last_month.beginning_of_month
      changed_end_at = Time.now.last_month.end_of_month
    elsif args[:ranges] == "last_month"
      start_from = Time.now.last_month.beginning_of_month
      end_at = Time.now.last_month.end_of_month
      chnaged_start_from = 2.months.ago.beginning_of_month
      changed_end_at = 2.months.ago.end_of_month
    elsif args[:ranges] == "this_quarter"
      start_from = Time.now.beginning_of_quarter 
      end_at = Time.now.end_of_quarter
      chnaged_start_from = @last_quarter_stat
      changed_end_at = Time.now.beginning_of_quarter
    elsif args[:ranges] == "last_quarter"
      start_from = @last_quarter_stat
      end_at = Time.now.beginning_of_quarter
      chnaged_start_from = @last_last_quarter_stat
      changed_end_at = @last_quarter_stat
    elsif args[:ranges] == "this_year"
      start_from = Time.now.beginning_of_year 
      end_at = Time.now.end_of_year
      chnaged_start_from = Time.now.last_year.beginning_of_year
      changed_end_at = Time.now.last_year.end_of_year
    elsif args[:ranges] == "last_year"
      start_from = Time.now.last_year.beginning_of_year
      end_at = Time.now.last_year.end_of_year
      chnaged_start_from = 2.years.ago.beginning_of_year
      changed_end_at = 2.years.ago.end_of_year
    end
    
    args[:records].each do |records|
      row_data += content_tag(:td, records.nonprofit_org.name)
      organization_surveys = NonprofitOrgsEarning.find(:all, :conditions => ['nonprofit_org_id = ? AND created_at BETWEEN ? AND ?', records.nonprofit_org.id, start_from, end_at])
      amount_earned = organization_surveys.collect {|r| r.amount_earned }
      total_amount = amount_earned.sum.us_dollar
      row_data += content_tag(:td, total_amount)
      row_data += content_tag(:td, organization_surveys.length)
      organization_surveys_prevperiod = NonprofitOrgsEarning.find(:all, :conditions => ['nonprofit_org_id = ? AND created_at BETWEEN ? AND ?', records.nonprofit_org.id, chnaged_start_from, changed_end_at])
      prev_amount_earned = organization_surveys_prevperiod.collect {|r| r.amount_earned }
      if prev_amount_earned.sum == "" || prev_amount_earned.sum == 0
        total_percent_changed = amount_earned.sum*100
      else
        total_percent_changed = (amount_earned.sum/prev_amount_earned.sum)*100
      end
      percent_changed = number_to_percentage(total_percent_changed, :precision => 0)
      row_data += content_tag(:td, percent_changed)
      table_rows += content_tag(:tr, row_data)
    end
    table_rows
  end
  
  def between_duration?(time, range)
    time.between?(range[:start], range[:end])
  end
  
end

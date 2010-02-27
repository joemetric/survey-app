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
    args[:records].each { |record|
      orgEarningDetails = getOrgEarningDetails(record.nonprofit_org.id, args[:ranges])
      row_data = content_tag(:td, record.nonprofit_org.name)
      row_data += content_tag(:td, orgEarningDetails[:total_amount])
      row_data += content_tag(:td, orgEarningDetails[:total_surveys])
      row_data += content_tag(:td, orgEarningDetails[:percentage_changed])
      table_rows += content_tag(:tr, row_data)
    }
    table_rows
  end
  
  def getOrgEarningDetails(org_id, range)
    date_range = getStartEndDateRanges(range)
    organization_surveys = NonprofitOrgsEarning.find(:all, :conditions => ['nonprofit_org_id = ? AND created_at BETWEEN ? AND ?', org_id, date_range[:start_from], date_range[:end_at]])
    amount_earned = organization_surveys.collect {|r| r.amount_earned }
    total_amount = amount_earned.sum.us_dollar
    organization_surveys_prevperiod = NonprofitOrgsEarning.find(:all, :conditions => ['nonprofit_org_id = ? AND created_at BETWEEN ? AND ?', org_id, date_range[:chnaged_start_from], date_range[:changed_end_at]])
    prev_amount_earned = organization_surveys_prevperiod.collect {|r| r.amount_earned }
    if prev_amount_earned.sum == 0
      total_percent_changed = "N/A"
    else
      total_percent_changed = number_to_percentage(((amount_earned.sum-prev_amount_earned.sum)/prev_amount_earned.sum)*100, :precision => 0)
    end
    {:total_amount => total_amount, :total_surveys => organization_surveys.length, :percentage_changed => total_percent_changed}
  end
  
  def getTimeRange(args)
    time_range = ''
    @quater_start = Date.today.beginning_of_quarter - 2.days
    @quarter_start_arr = @quater_start.to_s.split('-')
    @last_quarter_stat = Date.new(@quarter_start_arr[0].to_i, @quarter_start_arr[1].to_i, @quarter_start_arr[2].to_i).beginning_of_quarter.to_datetime
    if args[:ranges] == "today"
      time_range = Time.now.beginning_of_day.strftime('%Y %b %d %I:%M%p %Z')+" to "+Time.now.end_of_day.strftime('%Y %b %d %I:%M%p %Z')
    elsif args[:ranges] == "this_week"
      time_range = Time.now.beginning_of_week.strftime('%Y %b %d %I:%M%p %Z')+" to "+Time.now.end_of_week.strftime('%Y %b %d %I:%M%p %Z')
    elsif args[:ranges] == "last_week"
      time_range = 1.week.ago.beginning_of_week.strftime('%Y %b %d %I:%M%p %Z')+" to "+1.week.ago.end_of_week.strftime('%Y %b %d %I:%M%p %Z')
    elsif args[:ranges] == "this_month"
      time_range = Time.now.beginning_of_month.strftime('%Y %b %d %I:%M%p %Z')+" to "+Time.now.end_of_month.strftime('%Y %b %d %I:%M%p %Z')
    elsif args[:ranges] == "last_month"
      time_range = Time.now.last_month.beginning_of_month.strftime('%Y %b %d %I:%M%p %Z')+" to "+Time.now.last_month.end_of_month.strftime('%Y %b %d %I:%M%p %Z')
    elsif args[:ranges] == "this_quarter"
      time_range = Time.now.beginning_of_quarter.strftime('%Y %b %d %I:%M%p %Z')+" to "+Time.now.end_of_quarter.strftime('%Y %b %d %I:%M%p %Z')
    elsif args[:ranges] == "last_quarter"
      time_range = @last_quarter_stat.strftime('%Y %b %d %I:%M%p %Z')+" to "+Time.now.beginning_of_quarter.strftime('%Y %b %d %I:%M%p %Z')
    elsif args[:ranges] == "this_year"
      time_range = Time.now.beginning_of_year.strftime('%Y %b %d %I:%M%p %Z')+" to "+Time.now.end_of_year.strftime('%Y %b %d %I:%M%p %Z')
    elsif args[:ranges] == "last_year"
      time_range = Time.now.last_year.beginning_of_year.strftime('%Y %b %d %I:%M%p %Z')+" to "+Time.now.last_year.end_of_year.strftime('%Y %b %d %I:%M%p %Z')
    end
    time_range
  end
  
  def getStartEndDateRanges(args)
    @quater_start = Date.today.beginning_of_quarter - 2.days
    @quarter_start_arr = @quater_start.to_s.split('-')
    @last_quarter_stat = Date.new(@quarter_start_arr[0].to_i, @quarter_start_arr[1].to_i, @quarter_start_arr[2].to_i).beginning_of_quarter.to_datetime
    @last_quarter_start = @last_quarter_stat - 2.days
    @last_quarter_start_arr = @last_quarter_start.to_s.split('-')
    @last_last_quarter_stat = Date.new(@last_quarter_start_arr[0].to_i, @last_quarter_start_arr[1].to_i, @last_quarter_start_arr[2].to_i).beginning_of_quarter.to_datetime
    
    if args == "today"
      {:start_from => Time.now.beginning_of_day, :end_at => Time.now.end_of_day, :chnaged_start_from => 1.days.ago.beginning_of_day, :changed_end_at => 1.days.ago.end_of_day}
    elsif args == "this_week"
      {:start_from => Time.now.beginning_of_week, :end_at => Time.now.end_of_week, :chnaged_start_from => 1.week.ago.beginning_of_week, :changed_end_at => 1.week.ago.end_of_week}
    elsif args == "last_week"
      {:start_from => 1.week.ago.beginning_of_week, :end_at => 1.week.ago.end_of_week, :chnaged_start_from => 2.weeks.ago.beginning_of_week, :changed_end_at => 2.weeks.ago.end_of_week}
    elsif args == "this_month"
      {:start_from => Time.now.beginning_of_month, :end_at => Time.now.end_of_month, :chnaged_start_from => Time.now.last_month.beginning_of_month, :changed_end_at => Time.now.last_month.end_of_month}
    elsif args == "last_month"
      {:start_from => Time.now.last_month.beginning_of_month, :end_at => Time.now.last_month.end_of_month, :chnaged_start_from => 2.months.ago.beginning_of_month, :changed_end_at => 2.months.ago.end_of_month}
    elsif args == "this_quarter"
      {:start_from => Time.now.beginning_of_quarter, :end_at => Time.now.end_of_quarter, :chnaged_start_from => @last_quarter_stat, :changed_end_at => Time.now.beginning_of_quarter}
    elsif args == "last_quarter"
      {:start_from => @last_quarter_stat, :end_at => Time.now.beginning_of_quarter, :chnaged_start_from => @last_last_quarter_stat, :changed_end_at => @last_quarter_stat}
    elsif args == "this_year"
      {:start_from => Time.now.beginning_of_year, :end_at => Time.now.end_of_year, :chnaged_start_from => Time.now.last_year.beginning_of_year, :changed_end_at => Time.now.last_year.end_of_year}
    elsif args == "last_year"
      {:start_from => Time.now.last_year.beginning_of_year, :end_at => Time.now.last_year.end_of_year, :chnaged_start_from => 2.years.ago.beginning_of_year, :changed_end_at => 2.years.ago.end_of_year}
    end    
  end
  
  def between_duration?(time, range)
    time.between?(range[:start], range[:end])
  end
  
end

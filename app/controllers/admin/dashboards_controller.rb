class Admin::DashboardsController < ApplicationController
  
  layout 'admin', :except => [:downloadPDF, :downloadXLS]
  before_filter :require_admin
  before_filter :modify_params, :only => :demographic_distribution

  def index
  end
  
  def demographic_distribution
    unless params[:segment_by] == 'Nothing'
      @segment_by = params[:segment_by].titleize
      @segment_column = params[:segment_by] == 'age' ? 'age_id' : params[:segment_column]
      @segments = eval "User::#{params[:segment_by] == 'martial_status' ? 'MartialStatus' : @segment_by}"
    end
    unless params[:filter_by] == 'Select'
      if params[:filter_by] == 'age' && params[:segment_by] == 'Nothing'
        @filters = User.user_age_list
      else
        @results = User.consumers.all
      end
      @filter_by = params[:filter_by].titleize
      unless defined?(@filters)
        @filters = eval "User::#{params[:filter_by] == 'martial_status' ? 'MartialStatus' : @filter_by}"
      end
      @filter_column = params[:filter_by] == 'age' ? 'age_id' : params[:filter_column]
    end
  end
  
  def survey_distribution
    unless (params[:survey] == 'Select' || params[:survey_range] == 'Nothing')
      @results = eval "Survey.#{params[:survey]}"
      @segmented_data = eval "Survey.#{params[:survey_range]}"
      @header = params[:survey]
      @column = 'created_at' if params[:survey].eql?('submitted_surveys')
      @results_class = Survey::SurveyOptionClass[params[:survey]]
    end
  end
  
  def financial_distribution
    unless (params[:finance] == 'Select' || params[:finance_range] == 'Nothing')
      @results = eval "Survey.#{params[:finance]}"
      @header = params[:finance]
      @segmented_data = eval "Survey.#{params[:finance_range]}"
      @results_class = params[:finance] == 'gross_margin' ? 'Survey' : ''
    end
  end
  
  def nonprofit_organization_details
    unless (params[:time_range] == 'Select')
      @results = eval "NonprofitOrgsEarning.#{params[:time_range]}"
      @segmented_data = params[:time_range]
    end
  end
  
  def downloadPDF
    @results = eval "NonprofitOrgsEarning.#{params[:time_range]}"
    @segmented_data = params[:time_range]
    respond_to do |format|
      format.pdf do
        send_data(render(:template => 'admin/dashboards/downloadPDF.pdf.prawn', :layout => false),
          :filename => "JoeMetric_Report_for_#{getFileName(params[:time_range])}.pdf",
          :type => 'application/pdf',
          :disposition => 'attachment')
      end
    end
  end
  
  def downloadXLS
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="JoeMetric_Report_for_'"#{getFileName(params[:time_range])}"'.xls"'
    headers['Cache-Control'] = ''
    @results = eval "NonprofitOrgsEarning.#{params[:time_range]}"
    @segmented_data = params[:time_range]
  end
  
private
  
  def modify_params # TODO - Refactor
    User::Demographics.each {|d| 
      params.merge!({:filter_column => "#{d}_id"})  if params[:filter_by] == d.to_s
      params.merge!({:segment_column => "#{d}_id"}) if params[:segment_by] == d.to_s
    }
    params.merge!({:filter_column => 'birthdate'})  if params[:filter_by] == 'age'
    params.merge!({:segment_column => 'birthdate'}) if params[:segment_by] == 'age'
    params.merge!({:filter_column => 'gender'})     if params[:filter_by] == 'gender'
    params.merge!({:segment_column => 'gender'})    if params[:segment_by] == 'gender'
  end
  
  def getFileName(args)
    @quater_start = Date.today.beginning_of_quarter - 2.days
    @quarter_start_arr = @quater_start.to_s.split('-')
    @last_quarter_stat = Date.new(@quarter_start_arr[0].to_i, @quarter_start_arr[1].to_i, @quarter_start_arr[2].to_i).beginning_of_quarter.to_datetime
    
    if args == "today"
      Time.now.beginning_of_day.strftime('%Y%b%d_%I%M%p%Z')+"_to_"+Time.now.end_of_day.strftime('%Y%b%d_%I%M%p%Z')
    elsif args == "this_week"
      Time.now.beginning_of_week.strftime('%Y%b%d_%I%M%p%Z')+"_to_"+Time.now.end_of_week.strftime('%Y%b%d_%I%M%p%Z')
    elsif args == "last_week"
      1.week.ago.beginning_of_week.strftime('%Y%b%d_%I%M%p%Z')+"_to_"+1.week.ago.end_of_week.strftime('%Y%b%d_%I%M%p%Z')
    elsif args == "this_month"
      Time.now.beginning_of_month.strftime('%Y%b%d_%I%M%p%Z')+"_to_"+Time.now.end_of_month.strftime('%Y%b%d_%I%M%p%Z')
    elsif args == "last_month"
      Time.now.last_month.beginning_of_month.strftime('%Y%b%d_%I%M%p%Z')+"_to_"+Time.now.last_month.end_of_month.strftime('%Y%b%d_%I%M%p%Z')
    elsif args == "this_quarter"
      Time.now.beginning_of_quarter.strftime('%Y%b%d_%I%M%p%Z')+"_to_"+Time.now.end_of_quarter.strftime('%Y%b%d_%I%M%p%Z')
    elsif args == "last_quarter"
      @last_quarter_stat.strftime('%Y%b%d_%I%M%p%Z')+"_to_"+Time.now.beginning_of_quarter.strftime('%Y%b%d_%I%M%p%Z')
    elsif args == "this_year"
      Time.now.beginning_of_year.strftime('%Y%b%d_%I%M%p%Z')+"_to_"+Time.now.end_of_year.strftime('%Y%b%d_%I%M%p%Z')
    elsif args == "last_year"
      Time.now.last_year.beginning_of_year.strftime('%Y%b%d_%I%M%p%Z')+"_to_"+Time.now.last_year.end_of_year.strftime('%Y%b%d_%I%M%p%Z')
    end
  end
  
end

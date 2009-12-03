class Admin::DashboardsController < ApplicationController
  
  layout 'admin'
  before_filter :require_admin
  before_filter :modify_params, :only => :demographic_distribution
  
  def index
  end
  
  def demographic_distribution
    unless params[:segment_by] == 'Nothing'
      @segment_by = params[:segment_by].titleize
      @segment_column = params[:segment_by] ? 'age_id' : params[:segment_column]
      @segments = if @segment_by == 'Age'
        User.age_groups
      else
        eval "User::#{params[:segment_by] == 'martial_status' ? 'MartialStatus' : @segment_by}"
      end
    end
    unless params[:filter_by] == 'Select'
      @filter_by = params[:filter_by].titleize
      User.init_age_constant if params[:filter_by] == 'age'
      @filters = eval "User::#{params[:filter_by] == 'martial_status' ? 'MartialStatus' : @filter_by}"
      @filter_column = params[:filter_by] == 'age' ? 'age_id' : params[:filter_column]
      @results = User.demographic_data(params) unless @filter_column == 'age'
    end
  end
  
  def survey_distribution
    unless params[:survey_range] == 'Nothing'
      @surveys = Survey.finished
      @segmented_data = eval "Survey.#{params[:survey_range]}"
    end
  end
  
  def financial_distribution
    unless (params[:finance] == 'Select' || params[:finance_range] == 'Nothing')
      @results = eval "Survey.#{params[:finance]}"
      @header = params[:finance]
      @segmented_data = eval "Survey.#{params[:finance_range]}"
    end
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
  
end

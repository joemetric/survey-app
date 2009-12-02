class Admin::DashboardsController < ApplicationController
  
  layout 'admin'
  before_filter :require_admin
  before_filter :modify_params, :only => :demographic_distribution
  
  def index
  end
  
  def demographic_distribution
    @filter_by = params[:filter_by] == 'martial_status' ? 'Martial Status' : params[:filter_by].titleize
    @filters = eval "User::#{params[:filter_by] == 'martial_status' ? 'MartialStatus' : @filter_by}"
    @filter_column = params[:filter_column]
    unless params[:segment_by] == 'Nothing'
      @segment_by = params[:segment_by] == 'martial_status' ? 'Martial Status' : params[:segment_by].titleize
      @segments = eval "User::#{params[:segment_by] == 'martial_status' ? 'MartialStatus' : @segment_by}"
      @segment_column = params[:segment_column]
    end
    @results = User.demographic_data(params, (params[:segment_by] == 'Nothing' ? @filter_column : 'id'))
  end
  
  def survey_distribution
    unless params[:survey_range] == 'Nothing'
      @surveys = Survey.finished
      @segmented_data = eval "Survey.#{params[:survey_range]}"
    end
  end
  
private
  
  def modify_params
    User::Demographics.each {|d| 
      params.merge!({:filter_column => "#{d}_id"})  if params[:filter_by] == d.to_s
      params.merge!({:segment_column => "#{d}_id"}) if params[:segment_by] == d.to_s
    }
    ['zip_code', 'gender', 'age'].each do |column| # Special cases
      params.merge!({:filter_column => column})   if column.gsub('_', '') == params[:filter_by]
      params.merge!({:segment_column => column})  if column.gsub('_', '') == params[:segment_by]  
    end
  end
  
end

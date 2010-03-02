class RestrictionsController < ApplicationController
  before_filter :require_user
  
  def new
    @restriction = Restriction.new
  end

  def choose_type
    if Restriction::Kinds.include?(params[:restriction_type].to_sym)
      if params[:restriction_type] == 'martial_status'
        restriction_type = 'MartialStatus'
      elsif params[:restriction_type] == 'geographic_location'
        restriction_type = 'GeographicLocation'
      else
        restriction_type = params[:restriction_type].titleize
      end
      @restriction = eval "#{restriction_type}.new"
      @count = User.demographics_count(params[:survey])
      @constraint_count = User.count_by_criteria(User::DemographicColumns[params[:restriction_type].to_sym], pre_selected_demographic)
    end
  end
  
  def pre_selected_demographic
    params[:restriction_type] == 'martial_status' ? 'Male' : 1
  end
  
end

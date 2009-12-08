class RestrictionsController < ApplicationController
  before_filter :require_user
  
  def new
    @restriction = Restriction.new
  end

  def choose_type
    if Restriction::Kinds.include?(params[:restriction_type].to_sym)
      restriction_type = params[:restriction_type] == 'martial_status' ? 'MartialStatus' : params[:restriction_type].titleize
      @restriction = eval "#{restriction_type}.new"
    end
  end
  
end

class RestrictionsController < ApplicationController
  before_filter :require_user
  
  def new
    @restriction = Restriction.new
  end

  def choose_type
    if Restriction::Kinds.include?(params[:restriction_type].to_sym)
      @restriction = eval "#{params[:restriction_type].titleize}.new"
    end
  end
  
end

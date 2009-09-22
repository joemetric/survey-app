class RestrictionsController < ApplicationController

  def new
    validate_partial
    validate_container
  end
  
  protected
  
  def validate_partial
    @partial = Restriction::Kinds.include?(params[:type].to_sym) ? params[:type] : nil
  end
  
  def validate_container
    @container = params[:container]
  end

end

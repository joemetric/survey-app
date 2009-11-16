class ReportsController < ApplicationController
  
  before_filter :require_user
  
  def show
    @survey = Survey.find params[:id]
  end
  
end

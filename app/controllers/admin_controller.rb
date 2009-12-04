class AdminController < ApplicationController
  
  before_filter :require_admin
  layout 'admin'
  
  def index
    redirect_to dashboard_index_path and return
  end

end

class AdminController < ApplicationController
  layout 'admin'
  
  def index
    require_admin
  end

end

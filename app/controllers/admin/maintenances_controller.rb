class Admin::MaintenancesController < ApplicationController
  layout "admin"
  before_filter :require_admin
  resource_controller
  
  create.wants.html { redirect_to :action => "index" }
  update.wants.html { redirect_to :action => "index" }
  
end

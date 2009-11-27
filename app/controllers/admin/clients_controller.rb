class Admin::ClientsController < ApplicationController
  
  layout 'admin'
  before_filter :require_admin
  
  def index
    @maintenance = Maintenance.last(:conditions => ['passed = ?', false])
  end
  
end

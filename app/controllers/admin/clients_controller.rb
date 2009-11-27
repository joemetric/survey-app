class Admin::ClientsController < ApplicationController
  
  layout 'admin'
  before_filter :require_admin
  
  def index
    @maintenance = Maintenance.last(:conditions => ['passed = ?', false])
    @warning = Warning.activated
  end
  
  def warn
    @warning = Warning.new(params[:warning])
    @warning.added_by = current_admin.id
    if @warning.save
      flash[:notice] = 'Warning Preferences are set properly.'
      ajax_redirect(admin_clients_path)
    else
      show_error_messages(:warning, {:div => 'errors_warning'})
    end
  end
  
end

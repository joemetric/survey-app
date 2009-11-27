class Admin::MaintenancesController < ApplicationController

  layout "admin"
  before_filter :require_admin, :build_params
  
  def create
    @maintenance = Maintenance.new(params[:maintenance])
    if @maintenance.save
      flash[:notice] = 'System Downtime is scheduled successfully.'
      ajax_redirect(admin_clients_path)
    else
      show_error_messages(:maintenance)
    end
  end
  
  def build_params
    params.merge!({:maintenance => {:start => to_datetime(params, 'from'), :end => to_datetime(params, 'to')}})
  end
  
  def to_datetime(params, param_name)
    "#{correct_date(params[:on])} #{params['date'][param_name + '_hour']}:#{params['date'][param_name + '_minute']}:00"
  end
  
end

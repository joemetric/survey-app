class Admin::UsersController < ApplicationController
  
  before_filter :require_admin
  layout "admin"
  
  def index
    @users = User.all
  end
  
  def change_type
   user = User.find(params[:id])
   user.change_type(params[:type])
   alert_message('User Type is updated successfully')
  end
  
end

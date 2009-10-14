class Admin::UsersController < ApplicationController
  
  before_filter :require_admin
  before_filter :find_user, :only => [:change_type, :reset_password]
  layout "admin"
  
  def index
    @users = User.all
  end
  
  def change_type
   @user.change_type(params[:type])
   alert_message('User Type is updated successfully')
  end
  
  def reset_password
    unless request.get?
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      if @user.save
        @user.deliver_new_password_email(params[:user][:password])
        redirect_to admin_users_path
      else
        render :action => 'reset_password'
      end
    end
  end
  
  private
  
  def find_user
    @user = User.find(params[:id])
  end
    
end

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
  
  def blacklist
    blacklist_by = params[:blacklist_by]
    if User.exists?(blacklist_by.to_sym => params[blacklist_by])
      @user = User.find(:first, :conditions => {blacklist_by.to_sym => params[blacklist_by]})
      @user.add_to_blacklist
      flash[:notice] = "User of email address #{params[:email]} is blacklisted successfuly."
    else
      flash[:notice] = "User with #{blacklist_by.titleize} #{params[blacklist_by]} do not exists in the System."                  
    end
    redirect_to admin_clients_path
  end
  
  private
  
  def find_user
    @user = User.find(params[:id])
  end
    
end

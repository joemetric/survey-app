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
    if blacklist_by.nil_or_empty? || params[blacklist_by].nil_or_empty?
      flash[:notice] = "Please enter valid #{blacklist_by.titleize} Address to black list a user"
    else
      if BlackListing.send("find_or_create_by_#{blacklist_by}".to_sym, blacklist_by.to_sym => params[blacklist_by])
        flash[:notice] = "User of #{blacklist_by} #{params[blacklist_by]} is blacklisted successfuly."
      else
        flash[:notice] = "User with #{blacklist_by.titleize} #{params[blacklist_by]} do not exists in the System."
      end
    end
    redirect_to admin_clients_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

end

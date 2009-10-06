class Admin::UsersController < ApplicationController
  
  before_filter :require_admin
  layout "admin"
  
  def index
    @users = User.all
  end
  
end

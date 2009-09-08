class UsersController < ApplicationController
  resource_controller
  
  before_filter :require_user, :only => [ :edit, :update ]
  
  create.wants.html do
    sign_in object
    flash[:notice] = "Thanks for Signing Up! We're sending you an email with your activation code."
    render :action => "not_active"
  end
  
  def activate
    if object.activate(params[:key])
      flash[:notice] = "Your account is active now! Please sign in!"
      redirect_to user_session_new_path
    else
     flash[:notice] = "Sorry, but this token is not valid!" 
     render :action => "not_active"
   end
  end
  
  def send_reset
    object = User.find_by_email(params[:user][:email])
    unless object.blank?
      object.send_reset_instructions
      redirect_to new_user_session_path
    else
      flash[:notice] = "Sorry, but email informed is not valid!"
      render :action => "forgot_password"
    end
  end
  
  def reset_password
    object = User.find(params[:id])
    if object.valid_perishable_token?(params[:key])
      sign_in_without_password(object)
    else
      flash[:notice] = "Sorry, but token informed is not valid!"
      redirect_to new_user_session_path
    end
  end
  
  update.wants.html { redirect_to "/" }
    
  private
  
  def sign_in(person)
    UserSession.create(:login => person.login, :password => person.password)
  end
  
  def sign_in_without_password(object)
    UserSession.create(object)
  end

end

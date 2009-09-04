class UsersController < ApplicationController
  resource_controller
  
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
  
  def reset_password
    object = User.find_by_email(params[:user][:email])
    unless object.blank?
      object.reset_passwd
      redirect_to new_user_session_path
    else
      flash[:notice] = "Sorry, but email informed is not valid!"
      render :action => "forgot_password"
    end
  end
    
  private
  
  def sign_in(person)
    UserSession.create(:login => person.login, :password => person.password)
  end

end

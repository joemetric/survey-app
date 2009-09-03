class UserSessionsController < ResourceController::Base
  
  create.wants.html do
    flash[:notice] = "Logged in Successfully"
    redirect_to surveys_path 
  end
  
  def destroy
    current_person_session.destroy
    flash[:notice] = "Logged out Successfully"
    redirect_to new_user_session_path
  end
  
end

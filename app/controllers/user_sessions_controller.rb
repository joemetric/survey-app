class UserSessionsController < ApplicationController
  resource_controller  
  layout false

  create do 
    flash "Successfully logged!"
    wants.html { redirect_to "/" }
  end
  
  def destroy
    current_user_session.destroy
    render :action => "new"
  end
  
end
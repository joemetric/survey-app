class UserSessionsController < ApplicationController
  resource_controller  
  layout false
  
  index.wants.html { redirect_to :action => "new" }
  show.wants.html { redirect_to :action => "new" }
  
  create do 
    flash "Successfully logged!"
    wants.html { redirect_to "/" }
    wants.json { head :created, render :json => object.user }
    failure do
      wants.json { render :json => object.errors.to_json, :status => 422 }
    end
  end
  
  def destroy
    current_user_session.destroy
    render :action => "new"
  end
  
end
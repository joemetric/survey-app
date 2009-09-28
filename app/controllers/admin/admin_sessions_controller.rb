class Admin::AdminSessionsController < AdminController
  resource_controller
  layout false
  
  index do
    wants.html { redirect_to(:action => "new")}
  end
  
  create do 
    flash "Successfully logged!"
    wants.html { redirect_to(:controller => "admin", :action => "index") }
  end
  
  def destroy
    current_admin_session.destroy
    render :action => "new"
  end
  
  
end

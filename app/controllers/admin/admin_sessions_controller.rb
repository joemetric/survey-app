class Admin::AdminSessionsController < AdminController
  resource_controller
  layout false
  
  index do
    wants.html { redirect_to(:action => "new")}
  end
  
  create do 
    flash "Successfully logged!"
    wants.html { redirect_to admin_surveys_path }
  end
  
  def destroy
    current_admin_session.destroy
    render :action => "new"
  end
  
  
end

class Admin::AdminSessionsController < AdminController
  
  skip_before_filter :require_admin
  
  resource_controller
  layout false
  
  index.wants.html { redirect_to(:action => "new")}
  show.wants.html { redirect_to(:action => "new")}
  
  create do 
    flash "Successfully logged!"
    wants.html { redirect_to admin_surveys_path }
  end
  
  def destroy
    current_admin_session.destroy
    render :action => "new"
  end
  
  
end

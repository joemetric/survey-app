class UserSessionsController < ApplicationController
  resource_controller
  
  layout false
  
  skip_before_filter :verify_authenticity_token, :only => [ :create ]

  index.wants.html { redirect_to :action => "new" }
  
  show.wants.html { redirect_to :action => "new" }
  
  create do
    flash "Successfully logged!"
    wants.html { redirect_to next_page }
    wants.json { render :json => object.user, :status => 201 }
    failure do
      wants.json { render :json => object.errors.to_json, :status => 422 }
    end
  end
  
  def next_page
    (current_user.is_admin? || current_user.is_reviewer?) ? admin_surveys_path : surveys_path
  end
  
  def destroy
    current_user_session.destroy
    render :action => "new"
  end

end

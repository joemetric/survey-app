class UserSessionsController < ApplicationController
  resource_controller

  layout false

  skip_before_filter :verify_authenticity_token, :only => [ :create ]

  index.wants.html { redirect_to :action => "new" }

  show.wants.html { redirect_to :action => "new" }

  create.before do
    object.iphone_version = params[:client_version] if params.key? :client_version
    object.device_id = params[:device_id] if params.key? :device_id
  end

  create.after do
    session[:reviewer] = true if current_user.is_reviewer?
    object.user.update_attribute(:device_id, params[:device_id])
  end

  create do
    flash "Successfully logged!"
    wants.html { redirect_to next_page }
    wants.json {
      object.user.iphone_version = params[:client_version] if params.key? :client_version
      render :json => object.user, :status => 201
    }
    failure do
      wants.json { render :json => object.errors.to_json, :status => 422 }
    end
  end

  def next_page
    current_user.is_reviewer? ? review_admin_surveys_path : surveys_path
  end

  def destroy
    current_user_session.destroy if current_user_session
    render :action => "new"
  end

end

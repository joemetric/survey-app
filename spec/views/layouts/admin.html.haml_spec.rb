require File.dirname(__FILE__) + '/../../spec_helper'

# spec spec/views/layouts/admin.html.haml_spec.rb

describe "/layouts/admin" do
  fixtures :users
  
  before(:each) do
    Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(template.controller)
  end
  
  # Login and sign up links when no user logged in
  it "should show admin_login and no sign up link if no admin user logged in" do
    logout
    render :partial => "layouts/admin/header"
    response.should have_tag("a[href=?]", new_admin_admin_session_path) # Login link
    response.should_not have_tag("a[href=?]", new_user_path) # Sign up link
  end

  # Logout link and greeting text when user logged in
  it "should show greeting and logout link if admin user logged in" do
    admin_login_as(users(:admin))
    render :partial => "layouts/admin/header"
    response.should have_tag("a[href=?]", admin_admin_session_path) # Logout link
  end
  
  #User login
  def login_as(user)
    assigns[:current_user] = user
    template.controller.stub(:current_user).and_return(assigns[:current_user])
  end
  
  #Admin login
  def admin_login_as(user)
    assigns[:current_admin] = user
    template.controller.stub(:current_admin).and_return(assigns[:current_admin])
  end
  
  #Logout - make current_user nil
  def logout
    template.controller.stub(:current_user).and_return(nil)
  end
  
end
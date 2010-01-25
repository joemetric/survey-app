require File.dirname(__FILE__) + '/../../spec_helper'

# spec spec/views/layouts/application.html.haml_spec.rb

describe "/layouts/application" do
  fixtures :users
  
  before(:each) do
    Authlogic::Session::Base.controller = (@request && Authlogic::ControllerAdapters::RailsAdapter.new(@request)) || controller
  end
  
  # Login and sign up links when no user logged in
  it "should show login and sign up links if no user logged in" do
    logout
    render :partial => "layouts/header"
    response.should have_tag("a[href=?]", new_user_session_path) # Login link
    response.should have_tag("a[href=?]", new_user_path) # Sign up link
  end

  # Logout link and greeting text when user logged in
  it "should show greeting and logout link if user logged in" do
    login_as(users(:quentin))
    render :partial => "layouts/header"
    response.should contain(assigns[:current_user].name) # Greet user
    response.should have_tag("a[href=?]", user_session_path) # Logout link
  end
  
  #Login as james
  def login_as(user)
    assigns[:current_user] = user
    template.controller.stub(:current_user).and_return(assigns[:current_user])
  end
  
  #Logout - make current_user nil
  def logout
    template.controller.stub(:current_user).and_return(nil)
  end
  
  
end
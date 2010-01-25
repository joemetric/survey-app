require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# spec spec/controllers/user_sessions_controller_spec.rb

describe UserSessionsController do
  fixtures :users
  
  it "should show survey admin page for valid credentials" do
    post :create, :user_session => {:password => "piyush", :login => "reviewer_1"}
    response.should redirect_to(review_admin_surveys_path)
    response.should_not have_tag("a", :text => "Administrator")
    response.should_not have_tag("a", :text => "Client")
  end
  
  it "should get back to login page for invalid credentials" do
    post :create, :user_session => {:password => "wrong_password", :login => "reviewer_1"}
    response.should render_template("user_sessions/new")  
  end
  
end
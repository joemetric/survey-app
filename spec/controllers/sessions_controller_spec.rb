require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
#require 'sessions_controller'

describe UserSessionsController do

  fixtures :users

  def rescue_action(e)
     raise e
  end
  
  #def test_should_login_and_redirect
  it "should login and redirect" do
    post :create, :login => 'quentin', :password => 'monkey'
    session[:user_id].should_not == nil
    response.should redirect_to
  end

  #def test_should_fail_login_and_not_redirect
  it "should fail login and not redirect" do
    post :create, :login => 'quentin', :password => 'bad password'
    session[:user_id].should == nil
    response.should be_success
  end

  #def test_should_logout
  it "should logout" do
    login_as :quentin
    get :destroy
    session[:user_id].should == nil
    response.should redirect_to
  end

  #def test_should_remember_me
  it "should remember me" do
    request.cookies["auth_token"] = nil
    post :create, :login => 'quentin', :password => 'monkey', :remember_me => "1"
    response.cookies["auth_token"].should_not == nil
  end

  #def test_should_not_remember_me
  it "should not remember me" do
    request.cookies["auth_token"] = nil
    post :create, :login => 'quentin', :password => 'monkey', :remember_me => "0"
    puts response.cookies["auth_token"]
    response.cookies["auth_token"].blank.should be_true
  end
  
  #def test_should_delete_token_on_logout
  it "should delete token on logout" do
    login_as :quentin
    get :destroy
    response.cookies["auth_token"].blank.should be_true
  end

  #def test_should_login_with_cookie
  it "should login with cookie" do
    users(:quentin).remember_me(true)
    request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    controller.send(:logged_in?).should be_true
  end

  #def test_should_fail_expired_cookie_login
  it "should fail expired cookie login" do
    users(:quentin).remember_me(true)
    users(:quentin).update_attribute :remember_token_expires_at, 5.minutes.ago
    request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    controller.send(:logged_in?).should be_false
  end

  #def test_should_fail_cookie_login
  it "should fail cookie login" do
    users(:quentin).remember_me(false)
    request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    controller.send(:logged_in?).should be_false
  end

  protected
    def login_as(user)
      request.session[:user] = user ? users(user).id : nil
    end
    
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
end

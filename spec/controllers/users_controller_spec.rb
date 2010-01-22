require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

#  def rescue_action(e)
#    raise e
#  end
#
#  QUENTIN_ID = Fixtures::identify(:quentin)
#
#  fixtures :users
#
#  #def test_should_allow_signup
#  it "should allow signup" do
#      create_user
#      response.should redirect_to
#  end
#
#  #def test_should_require_login_on_signup
#  it "should require login on signup" do
#      create_user(:login => nil)
#      assigns(:user).errors.on(:login).should be_true
#      response.should be_success
#  end
#
#  #def test_should_require_password_on_signup
#  it "should require password on signup" do
#      create_user(:password => nil)
#      assigns(:user).errors.on(:password).should be_true
#      response.should be_success
#  end
#
#  #def test_should_require_password_confirmation_on_signup
#  it "should require password confirmatin on signup" do
#      create_user(:password_confirmation => nil)
#      assigns(:user).errors.on(:password_confirmation).should be_true
#      response.should be_success
#  end
#
#  #def test_should_require_email_on_signup
#  it "should require email on signup" do
#      create_user(:email => nil)
#      assigns(:user).errors.on(:email).should be_true
#      response.should be_success
#  end
#
#  #def test_should_sign_up_user_with_activation_code
#  it "should sign up user with activation code" do
#    create_user
#    assigns(:user).reload
#    assigns(:user).activation_code.should_not == nil
#  end
#
#  #def test_should_activate_user
#  it "should activate user" do
#    User.authenticate('aaron', 'test').should == nil
#    get :activate, :activation_code => users(:aaron).activation_code
#    response.should redirect_to('/sessions/new')
#    flash[:notice].should_not == nil
#    users(:aaron).should_be User.authenticate('aaron', 'monkey')
#  end
#
#  #def test_should_not_activate_user_without_key
#  it "should not activate user without key" do
#    get :activate
#    flash[:notice].should == nil
#  end
#
#
#  #def test_should_not_activate_user_with_blank_key
#  it "should not activate user with blank key" do
#    get :activate, :activation_code => ''
#    flash[:notice].should == nil
#  end
#
#  context "successfully updating user through json" do
#
#    setup do
#      login_as :quentin
#      put :update, :id=>QUENTIN_ID,
#        :user=>{:income=>'123456', :birthdate=>'21 May 2002', :gender=>'M'},:format=>'json'
#      @user = users(:quentin).reload
#    end
#
#    it "should cause fields to be updated" do
#      '123456'.should_be @user.income
#      Date::civil(2002, 5, 21).should_be @user.birthdate
#      'M'.should_be @user.gender
#
#    end
#
#    should_route :put, "/users/#{QUENTIN_ID}", :controller=>:users, :action=>:update, :id=>QUENTIN_ID
#
##    response.should be_success
##    response.should_be(content_type => :json)
#
#    it "should return user in json form" do
#      @user.to_json.should_be @response.body
#    end
#
#  end
#
#  context "attempting to update a user other than the logged-in user" do
#    setup do
#      login_as :aaron
#      put :update, :id=>QUENTIN_ID, :user=>{},:format=>'json'
#    end
#
# #   response.should_be :unprocessable_entity
#  end
#
#  context "failing to update user through json" do
#    setup do
#      login_as :quentin
#      put :update, :id=>QUENTIN_ID, :user=>{:email=>''}, :format=>'json'
#    end
#  #  response.should_be :unprocessable_entity
#  #  response.should_be(content_type => :json)
#
#    it "should contain the errors" do
#      /can\'t be blank/.should_match @response.body
#    end
#
#  end
#
#
#  context "showing logged in user, using json" do
#    setup do
#      login_as :quentin
#      get :show, :id=>'current', :format=>:json
#    end
#
##    response.should be_success
##    response.should_be(content_type => :json)
#
#    it "should return current user in json form" do
#      users(:quentin).to_json(:include => {:wallet => {:methods => :balance, :include => :wallet_transactions}}).should_be @response.body
#    end
#  end
#
#  context "show user without id current 404s" do
#    setup do
#      login_as :quentin
#      get :show, :id=>QUENTIN_ID, :format=>:json
#    end
#
##    response.should == 404
#  end
#
#
#  context "unauthenticated user" do
#    it "should be able to create user" do
#      post :create
#      response.should be_success
#    end
#
#    it "should be able to display new" do
#      get :new
#      response.should be_success
#    end
#
#    it "should be denied update" do
#      put :update, :id=>QUENTIN_ID, :user=>{},:format=>'json'
#      response.should == 401
#    end
#
#    it "should be denied show_current" do
#      get :show, :id=>'current', :user=>{},:format=>'json'
#      response.should == 401
#    end
#
#
#  end
#
#
#  protected
#    def login_as(user)
#      request.session[:user] = user ? users(user).id : nil
#    end
#    
#    def create_user(options = {})
#      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
#        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
#    end
end

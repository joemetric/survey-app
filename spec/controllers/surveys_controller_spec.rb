require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SurveysController do

  fixtures :users, :surveys

  def setup
    login_as :quentin
  end

  #def test_should_get_index
  it "should get index" do
    get :index
    response.should be_success
    assigns(:surveys).should_not == nil
  end

  #def test_should_get_new
  it "should get new" do
    get :new
    response.should be_success
  end

  #def test_should_create_survey
  it "should create survey" do
      post :create, :survey => { :name => "new survey"}

    response.should redirect_to(survey_path(assigns(:survey)))
  end

  #def test_should_show_survey
  it "should show survey" do
    get :show, :id => surveys(:one).id
    response.should be_success
  end

  #def test_should_get_edit
  it "should get edit" do
    get :edit, :id => surveys(:one).id
    response.should be_success
  end

  #def test_should_update_survey
  it "should update survey" do
    put :update, :id => surveys(:one).id, :survey => { }
    response.should redirect_to(survey_path(assigns(:survey)))
  end

  #def test_should_destroy_survey
  it "should destroy survey" do
    delete :destroy, :id => surveys(:one).id
    response.should redirect_to(surveys_path)
  end
  
  protected
    def login_as(user)
      request.session[:user] = user ? users(user).id : nil
    end
end

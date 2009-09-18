require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuestionsController do
  
  fixtures :surveys, :questions
  
  it "should get index" do
    get :index, :survey_id => surveys(:one).id
    response.should be_success
    assigns(:questions).should_not == nil
  end

  it "should get new" do
    get :new, :survey_id => surveys(:one).id
    response.should be_success
  end

  it "should create question" do
      post :create, :question => { :name => "Question text" }, :survey_id => surveys(:one).id

    response.should redirect_to(survey_question_path(surveys(:one), assigns(:question)))
  end

  it "should show question" do
    get :show, :id => questions(:one).id, :survey_id => surveys(:one)
    response.should be_success
  end

  it "should get edit" do
    get :edit, :id => questions(:one).id, :survey_id => surveys(:one)
    response.should be_success
  end

  it "should update question" do
    put :update, :id => questions(:one).id, :question => { }, :survey_id => surveys(:one)
    response.should redirect_to(survey_question_path(surveys(:one), assigns(:question)))
  end

  it "should destroy question" do
      delete :destroy, :id => questions(:one).id, :survey_id => surveys(:one)

    response.should redirect_to(survey_questions_path(surveys(:one)))
  end
end
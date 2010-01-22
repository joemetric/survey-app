require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# spec spec/controllers/admin/surveys_controller_spec.rb

describe Admin::SurveysController do
  fixtures :users, :surveys
  
  describe "Survey Approval" do
    before(:each) do
      admin_login
    end
    
    it "should get list of pending or rejected surveys " do
      survey = mock_model(Survey, :save => nil)
      Survey.should_receive(:for_approval)
      get :index
      response.should render_template("index")
    end
    
    it "should display a form to publish or reject survey" do 
      post :overview, :id => 10
      response.should render_template('overview.rjs')
    end
    
    it "should publish a survey" do
      put :publish, :id => "9"
      assigns[:survey] = mock_model(Survey, {:id => "9", :publish_status => 'rejected', :chargable_amount => "150"})
      assigns[:survey].publish_status.should == 'published'
      response.should redirect_to(admin_surveys_path)
    end
    
    it "should reject a survey" do
      put :reject, :id => "6", :survey => {:other_reject_reason => ""}
      survey = Survey.find("6")
      assigns[:survey].publish_status.should == 'rejected'
    end
  end
  
  it "should redirect to login page if no admin or reviewer is logged in" do
    controller.before_filters.should include(:require_admin_or_reviewer)
  end
  
  it "should get list of pending or rejected surveys " do
    get :index
    response.should redirect_to(new_admin_admin_session_url)
  end
  
  def admin_login
    assigns[:current_admin] = users(:admin)
    assigns[:current_reviewer] = users(:reviewer_1)
    controller.should_receive(:require_admin_or_reviewer).and_return true
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# spec spec/controllers/admin/dashboards_controller_spec.rb

describe Admin::DashboardsController do
  
   fixtures :users, :surveys
  
  before(:each) do
    controller.stub(:require_admin).and_return true
  end

 
  describe "Demographic Distribution" do
    it "should get user count based on filter_by option" do
      User.should_receive(:user_age_list)
      post :demographic_distribution, :filter_by => "age", :segment_by => 'Nothing'
      response.should render_template("demographic_distribution.rjs")
    end
    
    it "should get demographic distribution based on filter and segment" do 
      post :demographic_distribution, :filter_by => "race", :segment_by => 'gender'
      response.should render_template("demographic_distribution.rjs")
    end
  end
  
  describe "Survey Distribution" do
    it "should get user count based on filter_by option" do
      post :survey_distribution, :survey => "completed_surveys", :survey_range => "week_by_hours"
      response.should render_template("survey_distribution.rjs")
    end
  end
  
end

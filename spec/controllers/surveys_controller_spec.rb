require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# spec spec/controllers/surveys_controller_spec.rb

describe SurveysController do

    fixtures :users
    
    before(:each) do
      assigns[:current_user] = users(:james)
    end
  
    context "A Customer (in general)" do
      
      describe "Saved Surveys" do
        it "should be able to see list of surveys saved by him" do
          get :index
          assigns[:surveys] = Survey.saved.by(assigns[:current_user])
          assigns[:surveys].each do |survey|
            survey.publish_status.should == 'saved'
            survey.owner_id.should == assigns[:current_user].id
          end
        end
      end
      
      describe "Survey Reports" do
        it "should get to see list of his surveys which are published" do
          get :reports
          assigns[:surveys] = assigns[:current_user].created_surveys.published
          assigns[:surveys].each do |survey|
            survey.publish_status.should == 'published'
            survey.owner_id.should == assigns[:current_user].id
          end
        end
      end
    
    end

end

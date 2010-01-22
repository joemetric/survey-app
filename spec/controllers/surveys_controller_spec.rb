require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# spec spec/controllers/surveys_controller_spec.rb

describe SurveysController do

    fixtures :users, :surveys, :packages, :questions
    
    before(:each) do
      Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(SurveysController)
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
          assigns[:surveys] = users(:james).created_surveys.published
          assigns[:surveys].each do |survey|
            survey.publish_status.should == 'published'
            survey.owner_id.should == assigns[:current_user].id
          end
        end
      end
      
      describe "Create Survey" do
        
        it "should save survey with valid details" do
          post :create, create_survey_valid
          @survey = Survey.new(params["survey"]) 
          @survey.owner = users(:james)
          @survey.should be_valid
          @survey.questions.size.should == 2
        end
        
        it "should not save survey with invalid details" do
          post :create, create_survey_invalid
          @survey = Survey.new(params["survey"]) 
          @survey.should_not be_valid
        end
      end
      
      describe "Survey Update" do
        
        it "should update a survey for valid attributes" do
          put :update, valid_survey_params
          @survey = users(:james).created_surveys.find(params["survey"]["id"])
          @survey.owner_id.should == users(:james).id
          @survey.update_attributes(params["survey"]).should == true
          @survey.questions.size.should == 2
        end
        
        it "should not update a survey for invalid attributes" do
          put :update, invalid_survey_params
          @survey = users(:james).created_surveys.find(params["survey"]["id"])
          @survey.update_attributes(params["survey"]).should == false
        end
      end
      
      describe "Activate Surveys" do
        
        it "should activate a new survey with valid input" do
          post :activate, valid_survey_params 
          survey = Survey.new(params["survey"]) 
          survey.owner = users(:james)
          survey.save.should == true
          survey.publish_status.should == 'pending'
          survey.no_payment_required?.should == false
        end
        
        it "should not activate a new survey with invalid input" do
          post :activate, invalid_survey_params 
          survey = Survey.new(params["survey"]) 
          survey.owner = users(:james)
          survey.save.should == false
        end
        
      end
      
      def valid_survey_params
        { "survey" => {"end_at(1i)"=>"2009", 
                    "id" => "3",
                    "responses"=>"50", 
                    "name"=>"Who is better Google or Yahoo ? ", 
                    "end_at(2i)"=>"12", 
                    "ages_attributes"=>{"681356980"=>{"value"=>"2"}}, 
                    "end_at(3i)"=>"23", 
                    "description"=>"Techsavy ", 
                    "occupations_attributes"=>{"957095089"=>{"value"=>"2"}}, 
                    "questions_attributes"=>[
                                              { "name"=>"Search Speed",
                                                "id" => "3", 
                                                "options"=>"500,1000,3000", 
                                                "description"=>"Search Speed", 
                                                "question_type_id"=>"2"}, 
                                              { "name"=>"About Services", 
                                                "id" => "4",
                                                "description"=>"services description", 
                                                "question_type_id"=>"1"}], 
                    "package_id"=>"1"},
                    }
      end
      
      def create_survey_valid
        { "survey" => {"end_at(1i)"=>"2009", 
                    "responses"=>"50", 
                    "name"=>"Who is better Google or Yahoo ? ", 
                    "end_at(2i)"=>"12", 
                    "ages_attributes"=>{"681356980"=>{"value"=>"2"}}, 
                    "end_at(3i)"=>"23", 
                    "description"=>"Techsavy ", 
                    "occupations_attributes"=>{"957095089"=>{"value"=>"2"}}, 
                    "questions_attributes"=>[
                                              { "name"=>"Search Speed",
                                                "options"=>"500,1000,3000", 
                                                "description"=>"Search Speed", 
                                                "question_type_id"=>"2"}, 
                                              { "name"=>"About Services", 
                                                "description"=>"services description", 
                                                "question_type_id"=>"1"}], 
                    "package_id"=>"1"},
                    }
      end
      
      def create_survey_invalid
        {"survey" => {"end_at(1i)"=>"2009", 
                    "responses"=>"50", 
                    "name"=>" ", 
                    "end_at(2i)"=>"12", 
                    "ages_attributes"=>{"681356980"=>{"value"=>"2"}}, 
                    "end_at(3i)"=>"23", 
                    "description"=>"Techsavy ", 
                    "occupations_attributes"=>{"957095089"=>{"value"=>"2"}}, 
                    "questions_attributes"=>[
                                              { "name"=>" ", 
                                                "description"=>"services description", 
                                                "question_type_id"=>"1"}], 
                    "package_id"=>"1"} }
      end
      
      def invalid_survey_params
          {"survey" => {"end_at(1i)"=>"2009", 
                    "id" => "3",
                    "responses"=>"50", 
                    "name"=>" ", 
                    "end_at(2i)"=>"12", 
                    "ages_attributes"=>{"681356980"=>{"value"=>"2"}}, 
                    "end_at(3i)"=>"23", 
                    "description"=>"Techsavy ", 
                    "occupations_attributes"=>{"957095089"=>{"value"=>"2"}}, 
                    "questions_attributes"=>[
                                              { "name"=>" ", 
                                                "description"=>"services description", 
                                                "question_type_id"=>"1"}], 
                    "package_id"=>"1"} }
      end
      
      def free_survey_params
        {"survey" => {"end_at(1i)"=>"2009", 
                    "responses"=>"50", 
                    "name"=>"Free Survey", 
                    "end_at(2i)"=>"12", 
                    "end_at(3i)"=>"23", 
                    "description"=>"Techsavy ", 
                    "questions_attributes"=>[
                                              { "name"=>"Only Question of Survey", 
                                                "description"=>"services description", 
                                                "question_type_id"=>"1"}], 
                    "package_id"=>"3"} }
      end
      
      
      def login_as(user=nil)
        user = user || users(:james)
        controller.stub!(:current_user).and_return user
        assigns[:current_user]= user
      end
      
    end

end

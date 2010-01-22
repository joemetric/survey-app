require 'spec/spec_helper'

# spec spec/views/admin/surveys/index.html.haml_spec.rb

describe "/admin/surveys/index" do

  fixtures :surveys, :users
  
  before(:each) do
    Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(UsersController)
    assigns[:current_admin] = users(:admin)
    assigns[:surveys]= Survey.for_approval
  end
  
  describe "Survey List" do
    it "should have a table with headers Survey Name, Username, Last name, Date Submitted, Issue Refund" do
      render "/admin/surveys/index"
      response.should have_tag('table#table.sortable') do
        response.should have_tag('thead') do
          response.should have_tag('tr') do
             head_tag('Survey Name')
             head_tag('Username')
             head_tag('Last name')
             head_tag('Date Submitted')         
             head_tag('Issue Refund')         
          end
        end
      end
    end
    
    it "should list surveys in the table" do
      template.stub!(:render).with(hash_including(:partial => "/admin/surveys/survey", :collection => assigns[:surveys]))
      render :partial => "admin/surveys/survey", :collection => assigns[:surveys]
      if assigns[:surveys].size > 0
        assigns[:surveys].each do |survey|
          ["pending", "rejected"].should include(survey.publish_status) 
          response.should have_tag('tr') do |row|
            row.should have_tag('td') do |cell|
              cell.should have_tag("a", :text => survey.name)
            end
            row.should have_tag('td', :text => survey.owner.name)
            row.should have_tag('td', :text => survey.owner.last_name)
            row.should have_tag('td', :text => survey.created_at.to_date)
            row.should have_tag('td') do |cell|
              cell.should have_tag("a", :text => "Refund")
            end
          end
        end
      end
    end 
    
    it "should display form to approve or deny survey" do
      assigns[:survey] =  surveys(:one)
      render :partial => "/admin/surveys/survey_questions", :locals => {:survey => assigns[:survey]}
      response.should have_tag('a', :text => "Approve")
      response.should have_tag('a', :text => "Deny")
    end
 end
  
end
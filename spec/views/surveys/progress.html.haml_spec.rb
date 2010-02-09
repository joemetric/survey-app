require File.dirname(__FILE__) + '/../../spec_helper'

# spec spec/views/surveys/index.html.haml_spec.rb

describe "/surveys/progress" do

  fixtures :users, :surveys
  
  before(:each) do
    Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(SurveysController)
    assigns[:current_user] = users(:james)
    assigns[:surveys] = Survey.saved.by(assigns[:current_user])
  end
  
  it "should display list of surveys for current user" do
    assigns[:surveys]= assigns[:current_user].created_surveys
    render "/surveys/progress"
    response.should have_tag("ul.survey") do |ul|
      assigns[:surveys].each do |survey|
        ul.should have_tag("li#name_#{survey.id}") do |li|
          li.should have_tag("a", :text => "#{survey.name} (#{survey.publish_status})")
        end
      end
    end
  end
  
  it "should display survey progress graph in span" do
    assigns[:survey] = assigns[:current_user].created_surveys.first(:order => "id ASC")
    render "/surveys/progress"
    response.should have_tag("span#graph_#{assigns[:survey].id}") 
  end 
  
  it "should display suvey questions in tabular format" do
    assigns[:survey] = assigns[:current_user].created_surveys.first
    render :partial => "surveys/graph.html.haml"
    assigns[:survey].questions.each do |question| 
      response.should have_tag("table") do |table|
        table.should have_tag("tr") do |tr|
          tr.should have_tag("th") do |th|
            th.should have_tag("h3", :text => "Respondent #")
          end
          tr.should have_tag("th") do |th|
            th.should have_tag("h3", :text => question.name)
          end
        end
      end
    end
  end
  
  it "should display answers for the question" do
    assigns[:survey] = assigns[:current_user].created_surveys.first
    render :partial => "surveys/graph.html.haml"
    assigns[:survey].questions.each do |question|
      answers = Answer.by_question(question)
      response.should have_tag("table") do |table|
        if answers.blank?
          table.should have_tag("tr") do |tr|
            tr.should have_tag("td", :text => "No answers submitted yet")
          end
        else
          answers.each_with_index do |answer, i|
            table.should have_tag("tr") do |tr|
              tr.should have_tag("td", :text => i+1 )
              if answer.photo_response?
                tr.should have_tag("td", :text => answer.answer) 
              else
                tr.should have_tag("td") do |td|
                  td.should have_tag("a[href=?]", answer.image_url)
                end
              end
            end
          end
        end
      end
    end
  end
  
  it "should display information for at most one survey" do
     assigns[:surveys]= assigns[:current_user].created_surveys
    render "/surveys/progress"
    response.should have_tag("li.selected", :count => 1)
  end
  
end
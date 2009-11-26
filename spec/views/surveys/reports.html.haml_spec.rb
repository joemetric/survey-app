require File.dirname(__FILE__) + '/../../spec_helper'

# spec spec/views/surveys/reports.html.haml_spec.rb

describe "/surveys/reports" do
  
  fixtures :users, :surveys
  
  before(:each) do
    assigns[:current_user] = users(:james)
    assigns[:surveys] = assigns[:current_user].created_surveys.published
  end
  
  it "should have a table containing Survey data that has Name, Published At, Responses, Status headers" do
    do_render
    response.should have_tag('h3.heads', :text => 'Reports')
    response.should have_tag('table#table') do
      response.should have_tag('thead') do
        response.should have_tag('tr') do
           head_tag('Name')
           head_tag('Published At')
           head_tag('Responses')
           head_tag('Status')         
        end
      end
    end
  end
  
  it "should display survey list" do
    template.should_receive(:render).with(:partial => "/surveys/report_survey", :collection => assigns[:surveys])
    do_render
    response.should have_tag('tbody') do
      if assigns[:surveys].size > 0
        assigns[:surveys].each do |survey|
          have_tag('tr') do
            have_tag('td') do
              survey.completed? ? link_to_report_path(survey) : link_to_survey_path(survey)
            end
          end
        end
      end
    end
  end
  
  def link_to_survey_path(survey)
    have_tag('a[href=?]', survey_path(survey), :text => survey.name)
  end
  
  def link_to_report_path(survey)
    have_tag('a[href=?]', report_path(survey), :text => survey.name)
  end
  
  def do_render
    render '/surveys/reports'
  end
  
end
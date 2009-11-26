require File.dirname(__FILE__) + '/../../spec_helper'

# spec spec/views/surveys/index.html.haml_spec.rb

describe "/surveys/index" do
  
  fixtures :users
  
  before(:each) do
    assigns[:current_user] = users(:james)
    assigns[:surveys] = Survey.saved.by(assigns[:current_user])
  end
  
  it "should have a table containing with headers Name, Created On, Last Modified, # of Questions" do
    do_render
    response.should have_tag('h3.heads', :text => 'View Saved Surveys')
    response.should have_tag('table#table.sortable') do
      response.should have_tag('thead') do
        response.should have_tag('tr') do
           head_tag('Name')
           head_tag('Created On')
           head_tag('Last Modified')
           head_tag('# of Questions')         
        end
      end
    end
  end

  it "should display survey data in a table" do
    template.should_receive(:render).with(:partial => "/surveys/saved_survey", :collection => assigns[:surveys])
    do_render
    response.should have_tag('tbody') do
      if assigns[:surveys].size > 0
        assigns[:surveys].each do |survey|
          have_tag('tr') do
            have_tag('td') do
              have_tag('a[href=?]', edit_survey_path(survey), :text => survey.name)
            end
            response.have_tag('td', :text => survey.created_at.strftime("%b/%d/%Y"))
            response.have_tag('td', :text => survey.updated_at.strftime("%b/%d/%Y"))
            response.have_tag('td', :text => surveys.questions.size)
          end
        end
      end
    end
  end
  
  def do_render
    render '/surveys/index'
  end
  
end
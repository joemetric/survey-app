require File.dirname(__FILE__) + '/../../spec_helper'

# spec spec/views/surveys/progress.html.haml_spec.rb

describe "/surveys/index" do
  
  fixtures :users
  
  before(:each) do
    Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(SurveysController)
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

  it "should render survey partial with surveys saved by user" do
    template.should_receive(:render).with(hash_including(:partial => "/surveys/saved_survey", :collection => assigns[:surveys]))
    do_render
  end
    
  it "should display survey data in a table" do
    template.stub!(:render).with(hash_including(:partial => "/surveys/saved_survey", :collection => assigns[:surveys]))
    render :partial => "surveys/saved_survey", :collection => assigns[:surveys]
      if assigns[:surveys].size > 0
        assigns[:surveys].each do |survey|
          response.should have_tag('tr') do |row|
            row.should have_tag('td') do |cell|
              cell.should have_tag('a[href=?]', edit_survey_path(survey), :text => survey.name)
            end
            row.should have_tag('td', :text => survey.created_at.strftime("%b/%d/%Y"))
            row.should have_tag('td', :text => survey.updated_at.strftime("%b/%d/%Y"))
            row.should have_tag('td', :text => survey.questions.size) 
          end
      end
    end
  end
  
  def do_render
    render '/surveys/index'
  end
  
end
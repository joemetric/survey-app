require 'spec/spec_helper'

# spec spec/views/questions/report/multiple_choice.html.haml_spec.rb

describe "/questions/report/_multiple_choice" do
  
  fixtures :users
  
  before(:each) do
    assigns[:current_user] = users(:james)
    assigns[:survey] = Survey.by(assigns[:current_user]).find(10)
    assigns[:photo_response_questions] = assigns[:survey].photo_response_questions
  end


  
  it "should render multiple_choice partial for multiple choice type question" do
    assigns[:q] = mock_model(Question, {:survey_id => assigns[:survey].id, :question_type_id => 2, 
                                                                           :name => "Test multiple choice question", 
                                                                           :description => "Questions description",
                                                                           :complement => ["Yes", "No"]})
    render :partail => "/questions/report/multiple_choice", :object => assigns[:q], :locals => { :survey => assigns[:survey], :multiple_choice => assigns[:q]}
    response.should have_tag('table.sortable.nomargin') do |table|
      table.should have_tag('tr') do |row|
        row.should have_tag('th') do |cell|
          cell.should have_tag('h3', :text => "# of Responses")
          cell.should have_tag('h3', :text => "Choice")
        end
      end
      
      assigns[:q].complement.each do |option|
        table.should have_tag('tr') do |row|
          row.should have_tag('td')
          row.should have_tag('td')
        end
      end
    end
  end

end
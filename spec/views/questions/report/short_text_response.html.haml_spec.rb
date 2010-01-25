require 'spec/spec_helper'

# spec spec/views/questions/report/short_text_response.html.haml_spec.rb

describe "/questions/report/_short_text_response" do
  
  fixtures :users
  
  before(:each) do
    assigns[:current_user] = users(:james)
    assigns[:survey] = Survey.by(assigns[:current_user]).find(10)
    assigns[:photo_response_questions] = assigns[:survey].photo_response_questions
  end
  
  it "should render short_text response partial for short text response type question" do
    assigns[:q] = mock_model(Question, {:survey_id => assigns[:survey].id, :question_type_id => 1, :name => "Test short response question", :description => "Que "})
    render :partail => "questions/report/short_text_response", :locals => { :survey => assigns[:survey], :short_text_response => assigns[:q]}
    response.should have_tag('table') do |table|
      table.should have_tag('tr') do |row|
        row.should have_tag('th') do |cell|
          cell.should have_tag('h3', :text => "Individual Responses")
        end
        assigns[:survey].answers.by_question('short_text_response').each do |a|
          table.should have_tag('tr') do |row|
            row.should have_tag('td', :text => a.answer) 
          end
        end
      end
    end
  end

end
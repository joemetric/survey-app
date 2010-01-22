require File.dirname(__FILE__) + '/../../spec_helper'

# spec spec/views/reports/show.html.haml_spec.rb

describe "/reports/show" do
  
  fixtures :users
  
  before(:each) do
    assigns[:current_user] = users(:james)
    assigns[:survey] = Survey.by(assigns[:current_user]).find(10)
    assigns[:photo_response_questions] = assigns[:survey].photo_response_questions
  end
  
  it "should have a table containing Survey information that has Survey Title, # of Questions, # of Responses, End Date" do
    do_render
    response.should have_tag('h3.heads', :text => "#{assigns[:survey].name} Summary")
    response.should have_tag('table#table.sortable') do |table|
        table.should have_tag('tr') do |row|
           row.should have_tag("th", :text => "Survey Title")
           row.should have_tag("th", :text => "# of Questions")
           row.should have_tag("th", :text => "# of Responses")
           row.should have_tag("th", :text => "End date")         
        end
      table.should have_tag('tbody') do |tbody|
        tbody.should have_tag('tr') do |row|
          row.should have_tag("td", :text => assigns[:survey].name)
          row.should have_tag("td", :text => assigns[:survey].questions.size)
          row.should have_tag("td", :text => assigns[:survey].replies.size)
          row.should have_tag("td", :text => assigns[:survey].end_at.strftime("%b/%d %Y"))
        end
      end
    end
  end
  
  it "should have a table containing survey questions information" do
    do_render
    response.should have_tag('table#table2.sortable') do |table|
      table.should have_tag('thead') do |thead|
        thead.should have_tag('tr') do |row|
           row.should have_tag("th", :text => "#")
           row.should have_tag("th", :text =>"Question Name")
           row.should have_tag("th", :text =>"Type")
        end
      end
      table.should have_tag('tbody') do |tbody|
        assigns[:survey].questions.each_with_index do |question, i|
          tbody.should have_tag('tr') do |row|
            row.should have_tag('td', :text => i + 1)
            row.should have_tag('td', :text => question.name)
            row.should have_tag('td', :text => question.question_type.name)
          end
        end
      end
    end  
  end
  
  it "should have a link to Download Survey Anaylsis data in CSV" do
    do_render
    response.should have_tag('a[href=?]', csv_report_url(assigns[:survey]), :text => 'Download Survey Analysis Data in CSV')
  end
  
  it "should have download photo archive link when photo questions are available" do
    assigns[:photo_response_questions].stub!(:empty?).and_return(false)
    do_render
    response.should have_tag('a[href=?]',zip_archive_report_url(assigns[:survey]))
  end
  
  def do_render
    render '/reports/show'
  end

end  
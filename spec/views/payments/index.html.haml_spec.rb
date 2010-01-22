require File.dirname(__FILE__) + '/../../spec_helper'

# spec spec/views/payments/index.html.haml_spec.rb

describe "/payments/index" do
  
#  fixtures :users
#  
#  before(:each) do
#    assigns[:surveys] = users(:quentin).created_surveys.paginate(:all, :conditions => ['publish_status != ?', 'saved'], :page => params[:page], :per_page => 25)
#    do_render
#  end
#  
#  it "should display a table containing past transaction (payment) details" do
#    response.should have_tag('h3.heads', :text => 'Account History')
#    response.should have_tag('table#table') do
#      response.should have_tag('thead') do
#        response.should have_tag('tr') do
#           head_tag('Transaction ID')
#           head_tag('Survey Name')
#           head_tag('Number of Questions')
#           head_tag('Date Created')     
#           head_tag('Date Live')
#           head_tag('Date Completed')
#           head_tag('Amount')
#        end
#      end
#    end
#  end
#  
#  it "should display transaction list in table" do
#    response.should have_tag('tbody') do
#      if assigns[:surveys].size > 0
#        assigns[:surveys].each do |survey|
#          response.should have_tag('tr') do
#            have_tag('td', :text => survey.payment.transaction_id)
#            have_tag('td', :text => survey_link(survey))
#            have_tag('td', :text => survey.questions.size)
#            have_tag('td', :text => survey.created_at.to_date)
#            have_tag('td', :text => published_at(survey))
#            have_tag('td', :text => survey.end_at.to_date)
#            have_tag('td', :text => completed_at(survey))
#          end
#        end
#      end
#    end
#  end
#  
#  def do_render
#    render "payments/index.html.haml"
#  end
  
end  
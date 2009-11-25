require File.dirname(__FILE__) + '/../../spec_helper'

# spec spec/views/payments/index.html.haml_spec.rb

describe "/payments/index" do
  
  fixtures :users
  
  before(:each) do
    assigns[:payments] = users(:quentin).payments.complete.paginate(:all, :page => params[:page], :per_page => 10)
    do_render
  end
  
  it "should display a table containing past transaction (payment) details" do
    response.should have_tag('h3.heads', :text => 'Account History')
    response.should have_tag('table#table') do
      have_tag('thead') do
        have_tag('tr') do
           head_tag('Transaction ID')
           head_tag('Survey Name')
           head_tag('Number of Questions')
           head_tag('Date Created')     
           head_tag('Date Live')
           head_tag('Date Completed')
           head_tag('Amount')
        end
      end
    end
  end
  
  it "should display transaction list in table" do
    response.should have_tag('tbody') do
      if assigns[:payments].size > 0
        assigns[:payments].each do |payment|
          payment.transaction_id.should_not be_nil
          have_tag('tr') do
            have_tag('td', :text => payment.transaction_id)
            have_tag('td', :text => payment.survey.name)
            have_tag('td', :text => payment.survey.questions.size)
            have_tag('td', :text => payment.survey.created_at.to_date)
            have_tag('td', :text => payment.survey.published_at.to_date)
            have_tag('td', :text => payment.survey.end_at.to_date)
            have_tag('td', :text => payment.amount.us_dollar)
          end
        end
      end
    end
  end
  
  def do_render
    render "payments/index.html.haml"
  end
  
end  
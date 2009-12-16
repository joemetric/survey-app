require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# spec spec/controllers/payments_controller_spec.rb

describe PaymentsController do
  
  fixtures :users, :payments
  
  before(:each) do
    assigns[:current_user] = users(:quentin)
  end
  
  context "A Customer (in general)" do
    
    describe "Account History" do
    
      it "should be able to view details of all the past transactions made to pay for surveys" do
        get :index
        assigns[:surveys] = assigns[:current_user].created_surveys.paginate(:all, :conditions => ['publish_status != ?', 'saved'], :page => params[:page], :per_page => 25)
        assigns[:surveys].each do |survey|
          survey.publish_status.should_not == 'paid'
        end
      end
    
    end
   
  end

end  
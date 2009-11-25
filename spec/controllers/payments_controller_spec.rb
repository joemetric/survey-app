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
        assigns[:payments] = assigns[:current_user].payments.complete.paginate(:all, :page => params[:page], :per_page => 10)
        assigns[:payments].each do |payment|
          payment.owner_id.should == assigns[:current_user].id
          payment.transaction_id.should_not be_nil
          payment.status.should == 'paid'
        end
      end
    
    end
   
  end

end  
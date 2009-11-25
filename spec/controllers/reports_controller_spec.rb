require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# spec spec/controllers/reports_controller_spec.rb

describe ReportsController do
  
  fixtures :users, :surveys
    
  before(:each) do
    @current_user = users(:james)
  end
  
  context "A Customer (in general)" do
  
    describe "GET 'show'" do
      
      it "should be able to view analysis data (Report) of survey created by him" do
        get 'show', {:id => 10 }
        assigns[:survey] = Survey.by(@current_user).find(10)
        assigns[:survey].owner_id.should == @current_user.id
      end
        
    end
    
  end

end

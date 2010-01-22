require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# spec spec/controllers/admin/users_controller_spec.rb

describe Admin::UsersController do
   
  fixtures :users
   
  before(:each) do
    require_admin
  end
    
  describe "Reset Password" do
    it "should display reset password form" do
      get :reset_password, :id => 4
      controller.should render_template("reset_password")
    end
    
    describe "with valid input" do
      it "should update password as provided" do
        put :reset_password, :id => 4, :user => {:password => "check", :password_confirmation => "check"}
        assigns[:user].stub(:save).and_return(true)
        response.should redirect_to(admin_users_path)
      end
    end
    
    describe "with invalid input" do
      it "should not update password as provided" do
        put :reset_password, :id => 4, :user => {:password => "check", :password_confirmation => "check2"}
        assigns[:user].stub(:save).and_return(false)
        assigns[:user].should have(1).errors_on(:password)
        controller.should render_template("reset_password")
      end    
    end

  end
  
  describe "Change User Type" do
    it "should update user type" do
      put :change_type, :id => 4, :type => 'Admin'
      assigns[:user].stub(:change_type).with(params[:type]).and_return(true)
      response.should be_success 
    end
  end
  
  describe "Blacklist user" do
    it "should blacklist user by email" do
      put :blacklist, :blacklist_by => "email", :email => "consumer@joemetric.com"
      BlackListing.find_or_create_by_email(:email => params[:email]).should_not be_blank
      assigns[:blacklist_by] = params[:blacklist_by]
      flash[:notice].should == "User of email #{params[assigns[:blacklist_by]]} is blacklisted successfuly."
      response.should redirect_to(admin_clients_path)
    end
    
    it "should blacklist user by device" do
      put :blacklist, :blacklist_by => "device", :device => "00-0C-F1-56-98-AD"
      BlackListing.find_or_create_by_email(:device => params[:device]).should_not be_blank
      assigns[:blacklist_by] = params[:blacklist_by]
      flash[:notice].should == "User of device #{params[assigns[:blacklist_by]]} is blacklisted successfuly."
      response.should redirect_to(admin_clients_path)
    end
    
    it "should flash notice if blacklist_by is empty" do
      put :blacklist, :blacklist_by => ""
      assigns[:blacklist_by] = params[:device]
      flash[:notice].should == "Please enter valid #{assigns[:blacklist_by].titleize} Address to black list a user"
      response.should redirect_to(admin_clients_path)
    end
    
  end
  
  def require_admin
    controller.stub!(:current_admin).and_return mock_model(User)
  end
end

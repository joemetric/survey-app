require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# spec spec/controllers/admin/clients_controller_spec.rb

describe Admin::ClientsController do
  
  fixtures :users
  
  describe "Downtime administration" do
    it "should allow admin to access to schedule downtime" do
      admin_login
      get :index
      response.should render_template("admin/clients/index")
    end
    
    it "should NOT ALLOW non admin to access to schedule downtime" do
      assigns[:current_admin] = nil
      get :index
      response.should redirect_to(new_admin_admin_session_url)
    end
  end
  
  describe "Iphone warning administration" do
    it "should save warnings with valid input" do
      admin_login
      post :warn, :warning => {"warn_preference"=>"always", "warning"=>"Warning !!!", "iphone_version"=>"1.0"}
      assigns[:warning] = Warning.new(params[:warning])
      assigns[:warning].should be_valid
      flash[:notice].should_not be_nil
    end
    
    it "should not save warnings with invalid input" do
      admin_login
      post :warn, :warning => {"warn_preference"=>"always", "warning"=>"", "iphone_version"=>""}
      assigns[:warning] = Warning.new(params[:warning])
      assigns[:warning].should_not be_valid
    end
  end

  describe "Disable older iphone clients" do
    it "should not save iphone clients to be disabled" do
      admin_login
      post :disable, :disability =>{"warning"=>"Disabled !!!", "current_iphone_version"=>"1.3", "older_iphone_version"=>""}    
      assigns[:disability] = Disability.new(params[:disablity])
      assigns[:disability].should_not be_valid
    end
    
    it "should save iphone clients to be disabled" do
      admin_login
      post :disable, :disability =>{"warning"=>"Disabled !!!", "current_iphone_version"=>"1.3", "older_iphone_version"=>"1.0"}    
      assigns[:disability] = Disability.new(params[:disablity])
      assigns[:disability].should be_valid
      flash[:notice].should_not be_nil
    end
  end
  
  def admin_login
    @current_admin = controller.stub!(:current_admin).and_return mock_model(User, {:id => 1, :name => "Admin"})
    #controller.stub!(:require_admin).and_return true
  end
end

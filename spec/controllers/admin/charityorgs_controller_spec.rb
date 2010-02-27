require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# spec spec/controllers/admin/charityorgs_controller_spec.rb

describe Admin::CharityorgsController do
   
  fixtures :users, :nonprofit_orgs
   
  before(:each) do
    require_admin
  end
  
  context "An Admin (in general)" do
    
    describe "Create Organization" do
      
      it "should save organization with valid details" do
        post :create, create_organization_valid
        organization = NonprofitOrg.find_by_tax_id(params["organization"]["tax_id"])
        organization.active?.should == false
        organization.should be_valid
        response.should redirect_to(admin_charityorgs_url)
      end
      
      it "should not save organization with invalid details" do
        post :create, create_organization_invalid
        organization = NonprofitOrg.new(params["organization"])
        organization.should_not be_valid
        response.should render_template("new")
      end
      
    end
    
    describe "Edit Organization" do
      
      it "should show the flash notice if no organization is selected and Edit button clicked" do
        post :editOrganization, :commit => nil, :id => nil
        flash[:notice].should == "No organization is selected for editing"
        response.should redirect_to(admin_charityorgs_url)
      end
      
      it "should show the organization details in edit organization form for the organization selected for editing from the listing page" do
        post :editOrganization, :commit => nil, :id => 1
        NonprofitOrg.find_by_id(params[:id]).should_not be_blank
        response.should render_template("edit")
      end
      
      it "should update an organization for valid attributes" do
        put :editOrganization, valid_organization_params
        organization = NonprofitOrg.find_by_id(params[:organization][:id])
        organization.update_attributes(params["organization"]).should == true
        response.should redirect_to(admin_charityorgs_url)
      end
      
      it "should not update an organization for invalid attributes" do
        put :editOrganization, invalid_organization_params
        organization = NonprofitOrg.find_by_id(params[:organization][:id])
        organization.update_attributes(params["organization"]).should == false
        response.should render_template("edit")
      end
      
    end
    
    describe "Activate/Deactivate Organization Status" do
      
      it "should show the flash notice if there are no organizations available and Update button clicked to activate or deactivate organizations" do
        post :updateOrganization, :activeorg_ids => nil, :inactiveorg_ids => nil
        flash[:notice].should == "Please add at least one organization to update its status."
        response.should render_template("index")
      end
      
      it "should update the satus of the organizations listed in the inactive organization dropdown" do
        post :updateOrganization, :activeorg_ids => nil, :inactiveorg_ids => [1, 2]
        params[:inactiveorg_ids].each do |id|
          organization = NonprofitOrg.find_by_id(id).update_attributes(:active => false).should == true
        end
        flash[:notice].should == "Organization(s) status deactivated successfully"
        NonprofitOrg.exists?(:active => false).should be true
        response.should render_template("index")
      end
      
      it "should update the satus of the organizations listed in both the active and inactive organizations dropdown" do
        post :updateOrganization, :activeorg_ids => [3, 4], :inactiveorg_ids => [1, 2]
        params[:inactiveorg_ids].each do |id|
          organization = NonprofitOrg.find_by_id(id).update_attributes(:active => false).should == true
        end
        params[:activeorg_ids].each do |id|
          organization = NonprofitOrg.find_by_id(id).update_attributes(:active => true).should == true
        end
        flash[:notice].should == "Organization(s) status updated successfully"
        NonprofitOrg.exists?(:active => true).should be true
        NonprofitOrg.exists?(:active => false).should be true
        response.should render_template("index")
      end
      
    end
    
    def create_organization_valid
      { "organization" => 
        { "name" => "Testing Organization Created", 
          "address1" => "Testing Organization Address One",
          "city1" => "Testing Organization City One", 
          "state1" => "CA", 
          "zipcode1"=> "12345", 
          "address2" => "Testing Organization Address Two",
          "city2" => "Testing Organization City Two", 
          "state2" => "CA", 
          "zipcode2"=> "45678",
          "phone" => "1234567890",
          "email" => "testingorg@domain.com",
          "tax_status" => "Approved",
          "tax_id" => 1212121,
          "contact_name" => "Testing Contact Person Name",
          "contact_phone" => "1234548292",
          "website" => "http://www.testingorgdomain.com",
          "description" => "Testing Organization Description",
          "notes" => "Testing Organization Notes"
        }
      }
    end
      
    def create_organization_invalid
      { "organization" => 
        { "name" => " ", 
          "address1" => " ",
          "city1" => " ", 
          "state1" => " ", 
          "zipcode1"=> "1234523423", 
          "address2" => "Testing Organization Address Two",
          "city2" => "Testing Organization City Two", 
          "state2" => "CA", 
          "zipcode2"=> "45678",
          "phone" => "1234567890123123",
          "email" => "testingorg-at-domain-dot-com",
          "tax_status" => "Approved",
          "tax_id" => 12345,
          "contact_name" => "Testing Contact Person Name",
          "contact_phone" => "123454829223123",
          "website" => "http://www-dot-testingorgdomain-dot-com",
          "description" => "Testing Organization Description",
          "notes" => "Testing Organization Notes"
        }
      }
    end
    
    def valid_organization_params
      { "id" => "1",
        "organization" => 
        { "id" => "1",
          "name" => "Testing Organization Created", 
          "address1" => "Testing Organization Address One",
          "city1" => "Testing Organization City One", 
          "state1" => "CA", 
          "zipcode1"=> "12345", 
          "address2" => "Testing Organization Address Two",
          "city2" => "Testing Organization City Two", 
          "state2" => "CA", 
          "zipcode2"=> "45678",
          "phone" => "1234567890",
          "email" => "testingorg@domain.com",
          "tax_status" => "Approved",
          "tax_id" => 32376874,
          "contact_name" => "Testing Contact Person Name",
          "contact_phone" => "1234548292",
          "website" => "http://www.testingorgdomain.com",
          "description" => "Testing Organization Description",
          "notes" => "Testing Organization Notes"
        },
        "commit" => "Update"
      }
    end
      
    def invalid_organization_params
      { "id" => "1",
        "organization" => 
        { "id" => "1",
          "name" => " ", 
          "address1" => " ",
          "city1" => " ", 
          "state1" => " ", 
          "zipcode1"=> "1234523423", 
          "address2" => "Testing Organization Address Two",
          "city2" => "Testing Organization City Two", 
          "state2" => "CA", 
          "zipcode2"=> "45678",
          "phone" => "1234567890123123",
          "email" => "testingorg-at-domain-dot-com",
          "tax_status" => "Approved",
          "tax_id" => 6873410,
          "contact_name" => "Testing Contact Person Name",
          "contact_phone" => "123454829223123",
          "website" => "http://www-dot-testingorgdomain-dot-com",
          "description" => "Testing Organization Description",
          "notes" => "Testing Organization Notes"
        },
        "commit" => "Update"
      }
    end
      
  end
  
  it "should redirect to login page if no admin is logged in" do
    controller.before_filters.should include(:require_admin)
  end
  
  it "should get list of active or inactive charity organizations " do
    get :index
    response.should render_template("index")
  end
  
  def require_admin
    controller.stub!(:current_admin).and_return mock_model(User)
  end
end
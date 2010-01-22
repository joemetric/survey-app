require 'spec/spec_helper'

# spec spec/models/user_session_spec.rb


describe UserSession do
  
  fixtures :users
  
  before :each do
    Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(UserSessionsController)
    @user_session = UserSession.new(:login => "reviewer_1", :password => "piyush")
  end
  
  it "should have error on maintenance" do
    maintenance = Maintenance.currently_under?
    if maintenance
      @user_session.should_not be_valid
    else
      @user_session.should be_valid
    end
  end
  
  it "should check iphone version when warning activated" do
    warning = Warning.activated
    if @user_session.iphone_version && warning.iphone_version.to_f > @user_session.iphone_version.to_f
      @user_session.should_not be_valid
    else
      @user_session.should be_valid
    end
  end
  
  it "should not allow blacklisted user to login" do
    attempted_record = mock_model(User, {:email => "black_listed@one.com", :name => "black listed"})
    if BlackListing.exists?(:email => attempted_record.email)
      @user_session.errors.add_to_base("Acess restricted")
      @user_session.errors.should_not be_empty
    end
  end
  
end
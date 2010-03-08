# == Schema Information
# Schema version: 20100308160716
#
# Table name: users
#
#  id                                         :integer(4)      not null, primary key
#  login                                      :string(40)
#  name                                       :string(100)     default("")
#  email                                      :string(100)
#  crypted_password                           :string(40)
#  created_at                                 :datetime
#  updated_at                                 :datetime
#  birthdate                                  :date
#  gender                                     :string(255)
#  password_salt                              :string(255)
#  persistence_token                          :string(255)
#  perishable_token                           :string(255)
#  active                                     :boolean(1)
#  type                                       :string(255)     default("Consumer")
#  income_id                                  :integer(4)
#  zip_code                                   :string(255)
#  race_id                                    :integer(4)
#  education_id                               :integer(4)
#  occupation_id                              :integer(4)
#  martial_status_id                          :integer(4)
#  sort_id                                    :integer(4)      default(1), not null
#  device_id                                  :string(255)
#  last_warned_at                             :datetime
#  get_geographical_location_targeted_surveys :boolean(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
#  fixtures :users
#  
#  before(:each) do 
#    @user = User.new(valid_attributes)
#    ActionMailer::Base.deliveries = [ ]
#  end
#  
#  context "Valid Attributes" do 
#    should_validate_uniqueness_of :email
#    should_validate_uniqueness_of :login
#    should_validate_presence_of :name
#  end
#  
#  context "Creation" do
#    it "should be inactive when created" do
#      @user.save
#      @user.active?.should be(false)
#    end
#    
#    it "should deliver automatic the activation mail after creation" do
#      @user.save
#      ActionMailer::Base.deliveries.should have(1).mail
#      ActionMailer::Base.deliveries.first.subject.should == "[JoeMetric] Please activate your new account"
#      ActionMailer::Base.deliveries.first.to.should include(@user.email)
#    end
#  end
#  
#  context "Methods" do
#    it "should be able to activate the user through token" do
#      @user.save
#      @user.active?.should be(false)
#      @user.activate(@user.perishable_token).should be(true)
#      @user.active?.should be(true)
#    end
#    
#    it "should be able to check validate token" do
#      @user.save
#      @user.valid_perishable_token?(@user.perishable_token).should be(true)
#      @user.valid_perishable_token?("AAA").should be(false)
#    end
#    
#    it "should be able to validate old passwords" do 
#      @user.save
#      @user.old_password = "123456"
#      @user.old_password_valid?.should be(true)
#      @user.old_password = "123789"
#      @user.old_password_valid?.should be(false)
#    end
#    
#  end
#  
#  context "Security Measures" do
#    it "should always request password confirmation" do
#      @user.save
#      @user.password = "new_password"
#      @user.valid?.should be(false)
#      @user.errors.collect { |attr, msg| attr }.should include("password") 
#    end
#
#    it "should be able to change password (without the old one) only with security token" do
#      @user.save
#      @user.password = @user.password_confirmation = "new_password"
#      @user.valid?.should be(false)
#      @user.errors.collect { |attr, msg| attr }.should include("old_password")
#    end
#    
#  end
#  
#  context "Processes" do
#    it "should deliver reset instructions password" do 
#      @user.save
#      ActionMailer::Base.deliveries = [ ]
#      @user.send_reset_instructions.should be(true)
#      ActionMailer::Base.deliveries.should have(1).mail
#      ActionMailer::Base.deliveries.first.subject.should == "[JoeMetric] Here is the instructions to reset your password!"
#      ActionMailer::Base.deliveries.first.to.should include(@user.email)
#    end
#  end
#  
#  private
#  
#  def valid_attributes
#    { :name => "Valid User", 
#      :email => "another@email.com", 
#      :login => "valid",
#      :password => "123456",
#      :password_confirmation => "123456"
#    }
#  end
  
end

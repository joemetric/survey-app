require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Admin do
  fixtures :admins
  
  before(:each) do 
    @admin = Admin.new(valid_attributes)
  end
  
  private
  
  def valid_attributes
    { :name => "Super Admin", 
      :email => "admin@super.com", 
      :login => "admin",
      :password => "123456",
      :password_confirmation => "123456"
    }
  end
  
  
end

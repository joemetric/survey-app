# == Schema Information
# Schema version: 20091110082101
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  login             :string(40)
#  name              :string(100)     default("")
#  email             :string(100)
#  crypted_password  :string(40)
#  created_at        :datetime
#  updated_at        :datetime
#  birthdate         :date
#  gender            :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  perishable_token  :string(255)
#  active            :boolean(1)
#  type              :string(255)     default("User")
#  income_id         :integer(4)
#  zip_code          :string(255)
#

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

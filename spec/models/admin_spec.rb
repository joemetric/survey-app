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

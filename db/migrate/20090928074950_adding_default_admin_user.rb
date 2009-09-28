class AddingDefaultAdminUser < ActiveRecord::Migration
  def self.up
    Admin.create(
      { :email => "admin@joemetric.com", 
        :name => "Admin", 
        :login => "admin", 
        :password => "1dkgi341", 
        :password_confirmation => "1dkgi341"  
      }
    )
  end

  def self.down
  end
end

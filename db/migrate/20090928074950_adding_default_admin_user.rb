class AddingDefaultAdminUser < ActiveRecord::Migration
  def self.up
    # Default Admin User will be added from rake survey:db:default_users 
  end

  def self.down
  end
end

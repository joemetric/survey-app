class AddDefaultPackage < ActiveRecord::Migration
  def self.up
    # Default package data is added from rake survey:survey:db:default_packages
  end

  def self.down
    
  end
  
end
class AddZipCodeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :zip_code, :integer
  end

  def self.down
    remove_column :users, :zip_code, :integer
  end
end

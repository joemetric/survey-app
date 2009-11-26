class AddColumnBlacklistedInUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :blacklisted, :boolean, :default => false
  end

  def self.down
    remove_column :users, :blacklisted
  end
end

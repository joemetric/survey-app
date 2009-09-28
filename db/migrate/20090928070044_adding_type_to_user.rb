class AddingTypeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :type, :string, :default => "User"
  end

  def self.down
    remove_column :users, :type
  end
end

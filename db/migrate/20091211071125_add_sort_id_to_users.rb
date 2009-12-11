class AddSortIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :sort_id, :integer, :default => 1, :null => false
  end

  def self.down
    remove_column :users, :sort_id
  end
end

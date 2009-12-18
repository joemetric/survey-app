class AddLastWarnedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_warned_at, :datetime
  end

  def self.down
    remove_column :users, :last_warned_at
  end
end

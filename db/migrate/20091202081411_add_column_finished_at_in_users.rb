class AddColumnFinishedAtInUsers < ActiveRecord::Migration
  def self.up
    add_column :surveys, :finished_at, :datetime
  end

  def self.down
    remove_column :surveys, :finished_at
  end
end

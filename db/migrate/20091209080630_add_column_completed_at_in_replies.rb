class AddColumnCompletedAtInReplies < ActiveRecord::Migration
  def self.up
    add_column :replies, :completed_at, :datetime
  end

  def self.down
    remove_column :replies, :completed_at, :datetime
  end
end

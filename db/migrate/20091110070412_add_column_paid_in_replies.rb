class AddColumnPaidInReplies < ActiveRecord::Migration
  def self.up
    add_column :replies, :paid, :boolean, :default => false
  end

  def self.down
    remove_column :replies, :paid
  end
end

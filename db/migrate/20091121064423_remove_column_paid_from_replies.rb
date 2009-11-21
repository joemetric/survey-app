class RemoveColumnPaidFromReplies < ActiveRecord::Migration
  def self.up    
    remove_column :replies, :paid
  end

  def self.down
    add_column :replies, :paid, :boolean, :default => false
  end
end

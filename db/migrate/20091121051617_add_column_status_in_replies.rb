class AddColumnStatusInReplies < ActiveRecord::Migration
  def self.up
    add_column :replies, :status, :string, :default => 'incomplete'
  end

  def self.down
    remove_column :replies, :status    
  end
end

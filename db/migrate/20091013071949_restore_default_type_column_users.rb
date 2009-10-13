class RestoreDefaultTypeColumnUsers < ActiveRecord::Migration
  def self.up
    change_column_default :users, :type, 'User'
    execute("UPDATE users SET type = 'User' WHERE type = 'Customer';");
  end

  def self.down
    change_column_default :users, :type, 'Customer'
    execute("UPDATE users SET type = 'Customer' WHERE type = 'User';");
  end
end

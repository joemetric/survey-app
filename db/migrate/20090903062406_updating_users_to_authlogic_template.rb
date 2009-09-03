class UpdatingUsersToAuthlogicTemplate < ActiveRecord::Migration
  def self.up
    remove_column :users, :salt
    add_column :users, :password_salt, :string
    add_column :users, :persistence_token, :string
    add_column :users, :perishable_token, :string
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires_at
    remove_column :users, :activation_code
    remove_column :users, :activated_at
  end

  def self.down
    add_column :users, :activated_at, :datetime
    add_column :users, :activation_code, :string
    add_column :users, :remember_token_expires_at, :string
    add_column :users, :remember_token
    remove_column :users, :perishable_token
    remove_column :users, :persistence_token
    remove_column :users, :password_salt
    add_column :users, :salt, :string
  end
end

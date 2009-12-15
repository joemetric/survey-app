class ChangeDefaultTypeOfUsers < ActiveRecord::Migration
  def self.up
    change_column_default :users, :type, 'Consumer'
  end

  def self.down
    change_column_default :users, :type, nil
  end
end

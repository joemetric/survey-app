class AddColumnOwnerIdInPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :owner_id, :integer, :limit => 11
  end

  def self.down
    remove_column :payments, :owner_id
  end
end

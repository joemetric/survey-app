class AddStatusAndOwnerIdInPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :owner_id, :integer
    add_column :payments, :status, :string
  end

  def self.down
    remove_column :payments, :owner_id
    remove_column :payments, :status
  end
end

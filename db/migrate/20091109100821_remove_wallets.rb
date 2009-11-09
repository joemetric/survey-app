class RemoveWallets < ActiveRecord::Migration
  def self.up
    drop_table :wallets
  end

  def self.down
    create_table :wallets do |t|
      t.references :user
      t.timestamps
    end
  end
end

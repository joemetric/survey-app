class RemoveWalletsTransactions < ActiveRecord::Migration
  def self.up
    drop_table :wallet_transactions
  end

  def self.down
    create_table :wallet_transations do |t|
      t.references :wallet
      t.float :ammount
      t.string :description
      t.timestamps
    end
  end
end

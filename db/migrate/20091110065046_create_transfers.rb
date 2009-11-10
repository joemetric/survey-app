class CreateTransfers < ActiveRecord::Migration
  def self.up
    create_table :transfers do |t|
      t.integer :reply_id, :limit => 11
      t.string  :status,   :limit => 100, :default => 'pending'
      t.float   :amount
      t.text    :paypal_params
      t.timestamps
    end
  end

  def self.down
    drop_table :transfers
  end
end

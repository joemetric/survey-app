class CreateRefunds < ActiveRecord::Migration
  def self.up
    create_table :refunds do |t|
      t.integer :survey_id
      t.integer :owner_id
      t.float   :amount
      t.string  :refund_transaction_id
      t.text    :paypal_response
      t.boolean :complete
      t.string  :error_code
      t.timestamps
    end
  end

  def self.down
    drop_table :refunds
  end
end

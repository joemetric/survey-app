class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.float    :amount
      t.integer  :survey_id
      t.string   :payer_id
      t.string   :token
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end

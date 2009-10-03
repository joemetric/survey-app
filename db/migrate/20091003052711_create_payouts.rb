class CreatePayouts < ActiveRecord::Migration
  def self.up
    create_table :payouts do |t|
      t.integer :package_id
      t.integer :package_question_type_id
      t.float   :amount
      t.timestamps
    end
  end

  def self.down
    drop_table :payouts
  end
end

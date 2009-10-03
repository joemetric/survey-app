class CreatePackagePricings < ActiveRecord::Migration
  def self.up
    create_table :package_pricings do |t|
      t.integer :package_id
      t.integer :package_question_type_id
      t.integer :total_questions
      t.float   :standard_price
      t.float   :normal_price
      t.timestamps
    end
  end

  def self.down
    drop_table :package_pricings
  end
end

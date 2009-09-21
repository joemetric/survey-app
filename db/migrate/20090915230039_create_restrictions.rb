class CreateRestrictions < ActiveRecord::Migration
  def self.up
    create_table :restrictions do |t|
      t.references :survey
      t.string :kind
      t.text :value
      t.timestamps
    end
  end

  def self.down
    drop_table :restrictions
  end
end

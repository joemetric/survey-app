class CreateWarnings < ActiveRecord::Migration
  def self.up
    create_table :warnings do |t|
      t.string   :iphone_version
      t.text     :warning
      t.string   :warn
      t.boolean  :active, :default => true
      t.integer  :added_by
      t.timestamps
    end
  end

  def self.down
    drop_table :warnings
  end
end

class CreateDisabilities < ActiveRecord::Migration
  def self.up
    create_table :disabilities do |t|
      t.string   :current_iphone_version
      t.string   :older_iphone_version
      t.text     :warning
      t.boolean  :active, :default => true
      t.integer  :added_by
      t.timestamps
    end
  end

  def self.down
    drop_table :disabilities
  end
end

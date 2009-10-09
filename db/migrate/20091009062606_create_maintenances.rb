class CreateMaintenances < ActiveRecord::Migration
  def self.up
    create_table :maintenances do |t|
      t.datetime :start
      t.integer  :duration
      t.timestamps
    end
  end

  def self.down
    drop_table :maintenances
  end
end

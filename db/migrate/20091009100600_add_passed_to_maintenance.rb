class AddPassedToMaintenance < ActiveRecord::Migration
  def self.up
    add_column :maintenances, :passed, :boolean, :default => false
  end

  def self.down
    remove_column :maintenances, :passed
  end
end

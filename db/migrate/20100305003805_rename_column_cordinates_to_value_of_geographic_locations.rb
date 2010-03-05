class RenameColumnCordinatesToValueOfGeographicLocations < ActiveRecord::Migration
  def self.up
    rename_column :geographic_locations, :cordinates, :value
  end

  def self.down
    rename_column :geographic_locations, :value, :cordinates
  end
end

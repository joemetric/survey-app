class DropTableGeographicLocations < ActiveRecord::Migration
  def self.up
    drop_table :geographic_locations
  end

  def self.down
    create_table :geographic_locations do |t|
      t.belongs_to :survey
      t.belongs_to :user
      t.text :cordinates
      t.timestamps
    end
  end
end

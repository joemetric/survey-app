class CreateGeographicLocations < ActiveRecord::Migration
  def self.up
    create_table :geographic_locations do |t|
      t.belongs_to :survey
      t.belongs_to :user
      t.text :cordinates
      t.timestamps
    end
  end

  def self.down
    drop_table :geographic_locations
  end
end

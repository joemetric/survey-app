class RemoveUserIdColumnFromGeographicLocations < ActiveRecord::Migration
  def self.up
    remove_column :geographic_locations, :user_id
  end

  def self.down
    add_column :geographic_locations, :user_id, :integer
  end
end

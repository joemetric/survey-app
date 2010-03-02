class AddColumnPhysicalLocationRestrictionInSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :physical_location_restriction, :boolean, :default => false
  end

  def self.down
    remove_column :surveys, :physical_location_restriction
  end
end

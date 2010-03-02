class AddColumnGetGeographicalLocationTargetedSurveysInUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :get_geographical_location_targeted_surveys, :boolean, :default => false
  end

  def self.down
    remove_column :users, :get_geographical_location_targeted_surveys
  end
end

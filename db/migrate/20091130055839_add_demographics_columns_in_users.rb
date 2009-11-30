class AddDemographicsColumnsInUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :race_id, :integer
    add_column :users, :education_id, :integer
    add_column :users, :occupation_id, :integer
    add_column :users, :martial_status_id, :integer
  end

  def self.down
    remove_column :users, :race_id
    remove_column :users, :education_id
    remove_column :users, :occupation_id
    remove_column :users, :martial_status_id
  end
end

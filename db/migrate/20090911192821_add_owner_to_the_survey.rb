class AddOwnerToTheSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :owner_id, :integer
  end

  def self.down
    remove_column :surveys, :owner_id
  end
end

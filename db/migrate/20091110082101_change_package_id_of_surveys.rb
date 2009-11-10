class ChangePackageIdOfSurveys < ActiveRecord::Migration
  def self.up
    change_column :surveys, :package_id, :integer, :null => true
  end

  def self.down
    change_column :surveys, :package_id, :integer, :null => false
  end
end

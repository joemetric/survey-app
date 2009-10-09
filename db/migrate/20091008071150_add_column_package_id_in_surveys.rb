class AddColumnPackageIdInSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :package_id, :integer, :null => false
  end

  def self.down
    remove_column :surveys, :package_id
  end
end

class AddingDescriptionToSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :description, :string
  end

  def self.down
    remove_column :surveys, :description
  end
end

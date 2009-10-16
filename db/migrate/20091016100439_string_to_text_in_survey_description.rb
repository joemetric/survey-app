class StringToTextInSurveyDescription < ActiveRecord::Migration
  def self.up
    remove_column :surveys, :description
    add_column :surveys, :description, :text
  end

  def self.down
    remove_column :surveys, :description
    add_column :surveys, :description, :string
  end
end

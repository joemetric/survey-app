class AddEndAtToSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :end_at, :date
  end

  def self.down
    remove_column :surveys, :end_at
  end
end

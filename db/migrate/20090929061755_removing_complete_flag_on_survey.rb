class RemovingCompleteFlagOnSurvey < ActiveRecord::Migration
  def self.up
    remove_column :surveys, :complete
    remove_column :surveys, :amount
  end

  def self.down
    add_column :surveys, :complete, :boolean
    add_column :surveys, :amount, :float
  end
end

class AddDraftInSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :draft, :boolean, :default => false
  end

  def self.down
    remove_column :surveys, :draft
  end
end

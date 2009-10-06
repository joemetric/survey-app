class RemovingDraftMarkFromSurvey < ActiveRecord::Migration
  def self.up
    remove_column :surveys, :draft
  end

  def self.down
    add_column :surveys, :draft, :boolean
  end
end

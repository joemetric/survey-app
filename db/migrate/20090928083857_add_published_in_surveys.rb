class AddPublishedInSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :published_at, :datetime
  end

  def self.down
    remove_column :surveys, :published_at
  end
end

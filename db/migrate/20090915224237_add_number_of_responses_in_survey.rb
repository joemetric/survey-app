class AddNumberOfResponsesInSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :responses, :integer
  end

  def self.down
    remove_column :surveys, :responses
  end
end

class AddPublishStatusToSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :publish_status, :string
  end

  def self.down
    remove_column :surveys, :publish_status
  end
end

class AddDefaultValuePublishStatusOfSurveys < ActiveRecord::Migration
  def self.up
    change_column_default(:surveys, :publish_status, 'pending')
  end

  def self.down
    change_column_default(:surveys, :publish_status, nil)
  end
end

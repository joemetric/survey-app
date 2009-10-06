class AddingRejectReasonToSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :reject_reason, :string
  end

  def self.down
    remove_column :surveys, :reject_reason
  end
end

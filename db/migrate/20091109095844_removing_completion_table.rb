class RemovingCompletionTable < ActiveRecord::Migration
  def self.up
    drop_table :completions
  end

  def self.down
    create_table :completions do |table|
      table.references :user
      table.references :survey
      table.datetime :paid_on
      table.timestamps
    end
  end
end

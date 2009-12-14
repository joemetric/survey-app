class RenameColumnWarnOfWarnings < ActiveRecord::Migration
  def self.up
    rename_column :warnings, :warn, :warn_preference
  end

  def self.down
    rename_column :warnings, :warn_preference, :warn
  end
end

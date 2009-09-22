class ChangingKindToTypeToFollowStiPattern < ActiveRecord::Migration
  def self.up
    add_column :restrictions, :type, :string
    remove_column :restrictions, :kind
  end

  def self.down
    remove_column :restrictions, :type
    add_column :restrictions, :kind, :string
  end
end

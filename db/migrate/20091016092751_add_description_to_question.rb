class AddDescriptionToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :description, :string
  end

  def self.down
    remove_column :questions, :description
  end
end

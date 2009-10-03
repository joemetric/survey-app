class AddColumnBaseCostInPackages < ActiveRecord::Migration
  def self.up
    add_column :packages, :base_cost, :float
    add_column :packages, :total_responses, :integer
  end

  def self.down
    remove_column :packages, :base_cost
    remove_column :packages, :total_responses
  end
end

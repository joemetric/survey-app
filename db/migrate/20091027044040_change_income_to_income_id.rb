class ChangeIncomeToIncomeId < ActiveRecord::Migration
  def self.up
    add_column :users, :income_id, :integer
    remove_column :users, :income
  end

  def self.down
    add_column :users, :income, :integer
    remove_column :users, :income_id
  end
end

class AddColumnRewardAmountInSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :reward_amount, :float
  end

  def self.down
    remove_column :surveys, :reward_amount
  end
end

class AddColumnChargeableAmountInSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :chargeable_amount, :float
  end

  def self.down
    remove_column :surveys, :chargeable_amount
  end
end

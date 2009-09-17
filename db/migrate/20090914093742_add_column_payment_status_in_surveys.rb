class AddColumnPaymentStatusInSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :payment_status, :string
  end

  def self.down
    remove_column :surveys, :payment_status
  end
end

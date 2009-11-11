class ChangeColumnDefaultStatusOfPayments < ActiveRecord::Migration
  def self.up
    change_column_default(:payments, :status, 'incomplete')
  end

  def self.down # Let default value be incomplete while reverting
    change_column_default(:payments, :status, 'incomplete')
  end
end

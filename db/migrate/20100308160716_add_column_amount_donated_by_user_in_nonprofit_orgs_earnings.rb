class AddColumnAmountDonatedByUserInNonprofitOrgsEarnings < ActiveRecord::Migration
  def self.up
    add_column :nonprofit_orgs_earnings, :amount_donated_by_user, :float, :default => 0.0, :null => false
  end

  def self.down
    remove_column :nonprofit_orgs_earnings, :amount_donated_by_user
  end
end

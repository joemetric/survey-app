class CreateNonprofitOrgsEarnings < ActiveRecord::Migration
  def self.up
    create_table :nonprofit_orgs_earnings do |t|
      t.belongs_to :nonprofit_org
      t.belongs_to :survey
      t.belongs_to :user
      t.float      :amount_earned, :default => 0.0, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :nonprofit_orgs_earnings
  end
end

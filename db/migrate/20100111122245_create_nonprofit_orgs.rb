class CreateNonprofitOrgs < ActiveRecord::Migration
  def self.up
    create_table :nonprofit_orgs do |t|
      t.string :name, :limit => 255
      t.string :address1, :limit => 255
      t.string :city1, :limit => 100
      t.string :state1, :limit => 100
      t.string :zipcode1, :limit => 100
      t.string :address2, :limit => 255
      t.string :city2, :limit => 100
      t.string :state2, :limit => 100
      t.string :zipcode2, :limit => 100 
      t.string :phone, :limit => 100
      t.string :email, :limit => 100
      t.string :tax_status, :limit => 100
      t.integer :tax_id, :limit => 20
      t.string :contact_name, :limit => 255
      t.string :contact_phone, :limit => 100
      t.string :website, :limit => 255
      t.text :description
      t.text :notes
      t.boolean :active, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :nonprofit_orgs
  end
end

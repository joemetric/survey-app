class CreateBlackListings < ActiveRecord::Migration
  def self.up
    create_table :black_listings do |t|
      t.string :email
      t.string :device

      t.timestamps
    end

    add_index :black_listings, :email
    add_index :black_listings, :device

    remove_column :users, :blacklisted
    add_column :users, :device_id, :string
  end

  def self.down
    drop_table :black_listings
    add_column :users, :blacklisted, :boolean
    remove_column :users, :device_id
  end
end

class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
      t.string :name, :limit => 255
      t.string :code, :limit => 255
      t.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end

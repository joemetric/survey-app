class CreatePackageLifetimes < ActiveRecord::Migration
  def self.up
    create_table :package_lifetimes do |t|
      t.integer :package_id
      t.boolean :cancelled
      t.integer :total_uses
      t.date    :valid_from
      t.date    :valid_until
      t.integer :validity_type_id
      t.timestamps
    end
    
    # Create Package Lifetime for previously added packages
    
    Package.find(:all).each do |p| 
      PackageLifetime.create(:package_id => p.id, :cancelled => false, :validity_type_id => 1)
    end
    
  end

  def self.down
    drop_table :package_lifetimes
  end
end
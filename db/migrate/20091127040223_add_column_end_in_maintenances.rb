class AddColumnEndInMaintenances < ActiveRecord::Migration
  def self.up
    add_column :maintenances, :end, :datetime
  end

  def self.down
    remove_column :maintenances, :end
  end
end

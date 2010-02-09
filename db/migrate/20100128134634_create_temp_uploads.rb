class CreateTempUploads < ActiveRecord::Migration
  def self.up
    create_table :temp_uploads do |t|
      t.string :org_files, :limit => 255
      t.string :session_id, :limit => 255
      t.timestamps
    end
  end

  def self.down
    drop_table :temp_uploads
  end
end

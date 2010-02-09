class AddAttachmentsOrgFileToTempUpload < ActiveRecord::Migration
  def self.up
    add_column :temp_uploads, :org_file_file_name, :string
    add_column :temp_uploads, :org_file_content_type, :string
    add_column :temp_uploads, :org_file_file_size, :integer
    add_column :temp_uploads, :org_file_updated_at, :datetime
  end

  def self.down
    remove_column :temp_uploads, :org_file_file_name
    remove_column :temp_uploads, :org_file_content_type
    remove_column :temp_uploads, :org_file_file_size
    remove_column :temp_uploads, :org_file_updated_at
  end
end

class AddAttachmentsLogoToNonprofitOrg < ActiveRecord::Migration
  def self.up
    add_column :nonprofit_orgs, :logo_file_name, :string
    add_column :nonprofit_orgs, :logo_content_type, :string
    add_column :nonprofit_orgs, :logo_file_size, :integer
    add_column :nonprofit_orgs, :logo_updated_at, :datetime
  end

  def self.down
    remove_column :nonprofit_orgs, :logo_file_name
    remove_column :nonprofit_orgs, :logo_content_type
    remove_column :nonprofit_orgs, :logo_file_size
    remove_column :nonprofit_orgs, :logo_updated_at
  end
end

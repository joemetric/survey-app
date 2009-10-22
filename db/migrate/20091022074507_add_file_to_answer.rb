class AddFileToAnswer < ActiveRecord::Migration
  def self.up
    add_column :answers, :image_file_name, :string
    add_column :answers, :image_content_type, :string
    add_column :answers, :image_file_size, :integer
    add_column :answers, :image_updated_at, :datetime
  end

  def self.down
    remove_column :answers, :image_file_name
    remove_column :answers, :image_content_type
    remove_column :answers, :image_file_size
    remove_column :answers, :image_updated_at
  end
end

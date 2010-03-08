# == Schema Information
# Schema version: 20100308160716
#
# Table name: temp_uploads
#
#  id                    :integer(4)      not null, primary key
#  org_files             :string(255)
#  session_id            :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  org_file_file_name    :string(255)
#  org_file_content_type :string(255)
#  org_file_file_size    :integer(4)
#  org_file_updated_at   :datetime
#

class TempUpload < ActiveRecord::Base
  
  Paperclip::Attachment.interpolations[:session_id] = proc do |attachment, style|
    attachment.instance.session_id
  end
  
  if ["gniyes_integration", "staging", "joemetric_integration", "production"].include?(ENV["RAILS_ENV"])
    has_attached_file :org_file,
      :storage        => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :s3_permissions => 'public-read',
      :path           => "tmp_org_files/:session_id/:basename.:extension",
      :bucket         => "#{S3_CONFIG[ENV["RAILS_ENV"]]['bucket_name']}"
    validates_attachment_presence :org_file
    validates_attachment_size :org_file, :less_than => 5.megabytes
  else
    has_attached_file :org_file,
      :url  => "/images/tmp_org_files/:session_id/:basename.:extension",
      :path => ":rails_root/public/images/tmp_org_files/:session_id/:basename.:extension"
    validates_attachment_presence :org_file
    validates_attachment_size :org_file, :less_than => 5.megabytes
  end
end

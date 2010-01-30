# == Schema Information
# Schema version: 20100128134656
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
  
  if ENV["RAILS_ENV"] == "production"
    has_attached_file :org_file,
      :storage        => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :path           => lambda { |attachment| ":session_id/:basename.:extension" },
      :bucket         => 'JoeSurvey-Respondent-SurveyResponseFiles-GniYes-Integration'
  else
    has_attached_file :org_file,
      :url  => "/images/tmp_org_files/:session_id/:basename.:extension",
      :path => ":rails_root/public/images/tmp_org_files/:session_id/:basename.:extension"
    validates_attachment_presence :org_file
    validates_attachment_size :org_file, :less_than => 5.megabytes
  end
end
# == Schema Information
# Schema version: 20100128134656
#
# Table name: nonprofit_orgs
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  address1          :string(255)
#  city1             :string(100)
#  state1            :string(100)
#  zipcode1          :string(100)
#  address2          :string(255)
#  city2             :string(100)
#  state2            :string(100)
#  zipcode2          :string(100)
#  phone             :string(100)
#  email             :string(100)
#  tax_status        :string(100)
#  tax_id            :integer(4)
#  contact_name      :string(255)
#  contact_phone     :string(100)
#  website           :string(255)
#  description       :text
#  notes             :text
#  active            :boolean(1)
#  created_at        :datetime
#  updated_at        :datetime
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer(4)
#  logo_updated_at   :datetime
#

class NonprofitOrg < ActiveRecord::Base
  
  validates_presence_of :name
  validates_length_of :name, :within => 2..255, :if => Proc.new{|org| !org.blank? }
  validates_numericality_of :zipcode1, :within => 1..5, :if => Proc.new { |org| !org.zipcode1.blank? }
  validates_numericality_of :zipcode2, :within => 1..5, :if => Proc.new { |org| !org.zipcode2.blank? }
  validates_numericality_of :phone, :within => 1..10, :if => Proc.new { |org| !org.phone.blank? }
  validates_numericality_of :tax_id, :if => Proc.new { |org| !org.tax_id.blank? }
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :if => Proc.new { |org| !org.email.blank? }
  validates_format_of :website, :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :if => Proc.new { |org| !org.website.blank? }
  validates_numericality_of :contact_phone, :within => 1..10, :if => Proc.new { |org| !org.contact_phone.blank? }
  
  def get_organization_basedon_status(status)
    find(:all, :conditions => ['active >= ?', status])
  end
  
  if ENV["RAILS_ENV"] == "production"
    has_attached_file :logo,
      :styles => { :original => '250x250>', :small => "55x55#" },
      :storage        => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :path           => lambda { |attachment| ":attachment/:id_:style.:extension" },
      :bucket         => 'JoeSurvey-Respondent-SurveyResponseFiles-GniYes-Integration'
    validates_attachment_presence :logo
    validates_attachment_size :logo, :less_than => 5.megabytes
    validates_attachment_content_type :logo, :content_type => ['image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg']
  else
    has_attached_file :logo, 
                      :styles => { :original => '250x250>', :small => "55x55#" },
                      :url  => "/images/:attachment/:id_:style.:extension",
                      :path => ":rails_root/public/images/:attachment/:id_:style.:extension"
    validates_attachment_presence :logo
    validates_attachment_size :logo, :less_than => 5.megabytes
    validates_attachment_content_type :logo, :content_type => ['image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg']
  end
  
end
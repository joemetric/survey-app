# == Schema Information
# Schema version: 20100308160716
#
# Table name: disabilities
#
#  id                     :integer(4)      not null, primary key
#  current_iphone_version :string(255)
#  older_iphone_version   :string(255)
#  warning                :text
#  active                 :boolean(1)      default(TRUE)
#  added_by               :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

class Disability < ActiveRecord::Base
  
  validates_presence_of :warning, :older_iphone_version, :current_iphone_version
  
  validate :iphone_versions
  
  def iphone_versions
    if (older_iphone_version && current_iphone_version) && (older_iphone_version.to_f >= current_iphone_version.to_f)
      errors.add_to_base('Current iphone app version should be greator than older version')
    end
  end
  
  after_create :deactivate_old_disabilities
  
  def self.activated
    last(:conditions => ['active = ?', true])
  end
  
  def deactivate_old_disabilities
    self.class.update_all( "active = false", "id != #{id}" )  
  end
  
  def self.older_iphone_version
    activated.try(:older_iphone_version)
  end
  
end

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
    self.class.update_all( "active = 0", "id != #{id}" )  
  end
  
  def self.older_iphone_version
    activated.try(:older_iphone_version)
  end
  
end

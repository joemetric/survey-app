# == Schema Information
# Schema version: 20091127040223
#
# Table name: warnings
#
#  id                  :integer(4)      not null, primary key
#  iphone_version      :string(255)
#  warning             :text
#  warning_preference  :string(255)     This column will tell Iphone app is Warning is to be shown always or just once
#  active              :boolean(1)      default(TRUE)
#  added_by            :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

class Warning < ActiveRecord::Base
  
  validates_presence_of :warning, :iphone_version, :warn_preference
  
  after_create :deactivate_old_warnings
  
  def self.activated
    last(:conditions => ['active = ?', true])
  end
  
  def deactivate_old_warnings
    self.class.update_all( "active = 0", "id != #{id}" )  
  end
  
  def self.warn_preference
    activated.try(:warn_preference)
  end
  
end

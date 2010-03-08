# == Schema Information
# Schema version: 20100308160716
#
# Table name: maintenances
#
#  id         :integer(4)      not null, primary key
#  start      :datetime
#  duration   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  passed     :boolean(1)
#  end        :datetime
#

class Maintenance < ActiveRecord::Base
  
  validates_presence_of :start, :end
  
  named_scope :not_passed, :conditions => { :passed => false }
  
  after_create :set_duration, :expire_old_maintenances
  
  def validate
    errors.add_to_base('Please set time duration properly') if duration_in_minutes < 0
  end
  
  def set_duration
    update_attribute(:duration, duration_in_minutes)
  end
  
  def expire_old_maintenances
    self.class.update_all( "passed = 1", "id != #{id}" )  
  end
  
  def duration_in_minutes
    (send('end') - send('start')).round / 60
  end
  
  def self.currently_under?
    Maintenance.not_passed.each do |m|
      m.update_attribute(:passed, true) if m.end_time < Time.now
      comp = (m.start..m.end_time).include?(Time.now) ? m : nil
      return comp if comp
    end
    return false
  end
  
  def end_time
    start + duration.minutes
  end
  
end

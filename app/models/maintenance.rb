class Maintenance < ActiveRecord::Base
  validates_presence_of :start, :duration
  validates_numericality_of :duration
  
  named_scope :not_passed, :conditions => { :passed => false }
  
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

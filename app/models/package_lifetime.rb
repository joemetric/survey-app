# == Schema Information
# Schema version: 20100308160716
#
# Table name: package_lifetimes
#
#  id               :integer(4)      not null, primary key
#  package_id       :integer(4)
#  cancelled        :boolean(1)
#  total_uses       :integer(4)
#  valid_from       :date
#  valid_until      :date
#  validity_type_id :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

class PackageLifetime < ActiveRecord::Base
  
  belongs_to :package
  
  VALIDITY_TYPES = [
                    ['Valid Until Cancelled', 1], 
                    ['Valid for Fixed Uses', 2],
                    ['Valid for Specific Duration', 3]
                   ]
  
  validates_presence_of :validity_type_id, :on => :update
  validates_presence_of :total_uses, :if => Proc.new{|l| l.validity_type_id == 2}, :on => :update
  validates_presence_of :valid_from, :valid_until, :if => Proc.new{|l| l.validity_type_id == 3}, :on => :update
  
end

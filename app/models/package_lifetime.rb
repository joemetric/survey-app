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

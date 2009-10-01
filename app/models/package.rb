class Package < ActiveRecord::Base
  
  validates_presence_of :name, :code
  validates_length_of :name, :within => 2..255, :if => Proc.new{|n| !n.blank? }
  validates_length_of :code, :within => 2..255, :if => Proc.new{|c| !c.blank? }
  
  validates_format_of :code, :with => /^[\S]*$/, :if => Proc.new{|c| !c.blank? }
  
  def before_validation
    write_attribute(:code, code.strip)
  end
  
end

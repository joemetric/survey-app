class BlackListing < ActiveRecord::Base
  validates_uniqueness_of :email,  :unless => Proc.new {|b| b.email.blank?}
  validates_uniqueness_of :device, :unless => Proc.new {|b| b.device.blank?}
end

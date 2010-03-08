# == Schema Information
# Schema version: 20100308160716
#
# Table name: black_listings
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  device     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class BlackListing < ActiveRecord::Base
  validates_uniqueness_of :email,  :unless => Proc.new {|b| b.email.blank?}
  validates_uniqueness_of :device, :unless => Proc.new {|b| b.device.blank?}
end

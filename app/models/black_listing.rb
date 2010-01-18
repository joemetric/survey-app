class BlackListing < ActiveRecord::Base
  validates_uniqueness_of :email, :device
end

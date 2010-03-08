# == Schema Information
# Schema version: 20100308160716
#
# Table name: pictures
#
#  id         :integer(4)      not null, primary key
#  path       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Picture < ActiveRecord::Base
  has_one :answer
end

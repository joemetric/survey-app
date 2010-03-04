# == Schema Information
# Schema version: 20100302105306
#
# Table name: geographic_locations
#
#  id         :integer(4)      not null, primary key
#  survey_id  :integer(4)
#  user_id    :integer(4)
#  cordinates :text
#  created_at :datetime
#  updated_at :datetime
#

class GeographicLocation < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :user
  
end

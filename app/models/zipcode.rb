# == Schema Information
# Schema version: 20100308160716
#
# Table name: restrictions
#
#  id         :integer(4)      not null, primary key
#  survey_id  :integer(4)
#  value      :text
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#

class Zipcode < Restriction
  
  belongs_to :survey  
  
end

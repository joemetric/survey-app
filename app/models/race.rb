# == Schema Information
# Schema version: 20100302105306
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

class Race < Restriction
  
  belongs_to :survey
    
end

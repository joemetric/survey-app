# == Schema Information
# Schema version: 20100305003805
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

class Age < Restriction
  
  belongs_to :survey
    
end

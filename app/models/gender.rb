# == Schema Information
# Schema version: 20091012054719
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

class Gender < Restriction
    
  Values = [ :male, :female ]
  
  belongs_to :survey
    
end

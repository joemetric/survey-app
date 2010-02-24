# == Schema Information
# Schema version: 20100222134333
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

class Restriction < ActiveRecord::Base
  
  Kinds = [ :gender, :zipcode, :occupation, :race, :education, :income, :age, :martial_status ]
  
  belongs_to :survey
  
end


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

class Restriction < ActiveRecord::Base
  # :geographic_location removed for now
  Kinds = [ :gender, :zipcode, :occupation, :race, :education, :income, :age, :marital_status, :geographic_location ]
  
  belongs_to :survey
  
end


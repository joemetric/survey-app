# == Schema Information
# Schema version: 20100308160716
#
# Table name: survey_pricings
#
#  id                 :integer(4)      not null, primary key
#  survey_id          :integer(4)
#  package_pricing_id :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

class SurveyPricing < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :package_pricing
  
end

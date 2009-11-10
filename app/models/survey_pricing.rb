class SurveyPricing < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :package_pricing
  
end

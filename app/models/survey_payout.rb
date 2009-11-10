class SurveyPayout < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :payout
    
end

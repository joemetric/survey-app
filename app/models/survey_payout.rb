# == Schema Information
# Schema version: 20100305003805
#
# Table name: survey_payouts
#
#  id         :integer(4)      not null, primary key
#  survey_id  :integer(4)
#  payout_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class SurveyPayout < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :payout
    
end

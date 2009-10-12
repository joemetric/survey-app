# == Schema Information
# Schema version: 20091012054719
#
# Table name: completions
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  survey_id  :integer(4)
#  paid_on    :date
#  created_at :datetime
#  updated_at :datetime
#

class Completion < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  
  after_create :update_wallet
  
  def update_wallet
    user.wallet.record_completed_survey( survey )
    self.paid_on = Date.today
    self.save
  end
end

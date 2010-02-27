# == Schema Information
# Schema version: 20100222134333
#
# Table name: nonprofit_orgs_earnings
#
#  id               :integer(4)      not null, primary key
#  nonprofit_org_id :integer(4)
#  survey_id        :integer(4)
#  user_id          :integer(4)
#  amount_earned    :float           default(0.0), not null
#  created_at       :datetime
#  updated_at       :datetime
#

class NonprofitOrgsEarning < ActiveRecord::Base
  
  TimeRange = [
    ['today', 'Today'],
    ['this_week', 'This Week'],
    ['last_week', 'Last Week'],
    ['this_month', 'This Month'],
    ['last_month', 'Last Month'],
    ['this_quarter', 'This Quarter'],
    ['last_quarter', 'Last Quarter'],
    ['this_year', 'This Year'],
    ['last_year', 'Last Year']
  ]

end
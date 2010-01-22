# == Schema Information
# Schema version: 20091127040223
#
# Table name: surveys
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  owner_id          :integer(4)
#  payment_status    :string(255)
#  end_at            :date
#  responses         :integer(4)
#  published_at      :datetime
#  publish_status    :string(255)
#  reject_reason     :string(255)
#  package_id        :integer(4)
#  chargeable_amount :float
#  description       :text

class Survey < ActiveRecord::Base
  
  Distribution = [
    ['hours_by_minutes', '5 Hours by 5 Minutes'],
    ['days_by_hours', '2 Days by Hours'],
    ['week_by_hours', '1 Week by Hours'],
    ['month_by_days', '1 Month by Days'],
    ['three_months_by_weeks', '3 Months by Weeks'],
    ['six_months_by_weeks', '6 Month by Weeks'],
    ['year_by_months', '1 Year by Months']
  ]
  
  FinanceOptions = [
    ['paid_out', '$$ Paid Out'],
    ['taken_in', '$$ Taken In'],
    ['gross_margin', 'Gross Margin %']
  ]
  
  SurveyOptions = [
    ['completed_surveys', '# Completed Surveys'],
    ['registered_respondents', '# Registered Respondents'],
    ['submitted_surveys', '# Company Submitted Surveys'],
    ['registered_companies', '# Registered Companies']
  ]
  
  SurveyOptionClass = {
    'completed_surveys' => 'Survey',
    'registered_respondents' => 'Consumer',
    'submitted_surveys' => 'Survey',
    'registered_companies' => 'User'
  }  
  
  NumberWords = {'three' => 3, 'six' => 6}
  
  def self.hours_by_minutes(hours=5)
   {:ranges => (1..(hours * 60)).to_a.to_range(5, 5).to_time_range('minutes', 10), :header => 'Minute'}
  end
  
  def self.days_by_hours(hours=48)
    {:ranges => (1..hours).to_a.to_time_range('hours'), :header => 'Hour'}
  end
  
  def self.week_by_hours
    days_by_hours((7 * 24))
  end
  
  def self.month_by_days
    {:ranges => (1..days_in(Date.today.month - 1)).to_a.to_time_range('days'), :header => 'Day'}
  end
  
  ['three', 'six'].each do |month|
    eval  "def self.#{month}_months_by_weeks;  month_by_weeks(#{NumberWords[month]}) end "
  end
  
  def self.month_by_weeks(months)
    time_lap = Time.now - months.send('months')
    total_weeks = total_weeks_in(Time.now, time_lap)
    return {:ranges => (1..total_weeks).to_a.to_time_range('weeks'), :header => 'Week'}
  end
  
  def self.year_by_months
    {:ranges => (1..12).to_a.to_time_range('months'), :header => 'Month'}
  end  
  
  def self.days_in(month_num)
   (Date.new(Time.now.year,12,31).to_date<<(12-month_num)).day
  end
  
  def self.total_weeks_in(from_time, to_time)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_seconds = ((to_time - from_time).abs).round
    weeks = 0
    if distance_in_seconds >= 1.send('week')
      delta = (distance_in_seconds / 1.send('week')).floor
      distance_in_seconds -= delta.send('week')
      weeks += delta
    end
    weeks
  end
  
  def self.taken_in
    Payment.complete
  end
  
  def self.paid_out
    Transfer.paid
  end
  
  def self.completed_surveys
    Reply.paid_or_complete
  end

  def self.registered_respondents
    User.consumers
  end
  
  def self.submitted_surveys
    pending
  end
  
  def self.registered_companies
    User.customers
  end
  
  def self.gross_margin
    finished
  end
  
end
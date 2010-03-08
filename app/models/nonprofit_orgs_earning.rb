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
  
  belongs_to :nonprofit_org
  belongs_to :user
  belongs_to :survey

  @quater_start = Date.today.beginning_of_quarter - 2.days
  @quarter_start_arr = @quater_start.to_s.split('-')
  @last_quarter_stat = Date.new(@quarter_start_arr[0].to_i, @quarter_start_arr[1].to_i, @quarter_start_arr[2].to_i).beginning_of_quarter.to_datetime

  cols = NonprofitOrgsEarning.column_names.collect {|c| "nonprofit_orgs_earnings.#{c}"}.join(",")
  
  if DB_CONFIG[ENV["RAILS_ENV"]]["adapter"] == "postgresql"
    named_scope :today, { :select => "DISTINCT ON (nonprofit_orgs_earnings.nonprofit_org_id) #{cols}", :conditions => ['created_at BETWEEN ? AND ?', Time.now.beginning_of_day, Time.now.end_of_day]}
    named_scope :this_week, { :select => "DISTINCT ON (nonprofit_orgs_earnings.nonprofit_org_id) #{cols}", :conditions => ['created_at BETWEEN ? AND ?', Time.now.beginning_of_week, Time.now.end_of_week]}
    named_scope :last_week, { :select => "DISTINCT ON (nonprofit_orgs_earnings.nonprofit_org_id) #{cols}", :conditions => ['created_at BETWEEN ? AND ?', 1.week.ago.beginning_of_week, 1.week.ago.end_of_week]}
    named_scope :this_month, { :select => "DISTINCT ON (nonprofit_orgs_earnings.nonprofit_org_id) #{cols}", :conditions => ['created_at BETWEEN ? AND ?', Time.now.beginning_of_month, Time.now.end_of_month]}
    named_scope :last_month, { :select => "DISTINCT ON (nonprofit_orgs_earnings.nonprofit_org_id) #{cols}", :conditions => ['created_at BETWEEN ? AND ?', Time.now.last_month.beginning_of_month, Time.now.last_month.end_of_month]}
    named_scope :this_quarter, { :select => "DISTINCT ON (nonprofit_orgs_earnings.nonprofit_org_id) #{cols}", :conditions => ['created_at BETWEEN ? AND ?', Time.now.beginning_of_quarter, Time.now.end_of_quarter]}
    named_scope :last_quarter, { :select => "DISTINCT ON (nonprofit_orgs_earnings.nonprofit_org_id) #{cols}", :conditions => ['created_at BETWEEN ? AND ?', @last_quarter_stat, Time.now.beginning_of_quarter]}
    named_scope :this_year, { :select => "DISTINCT ON (nonprofit_orgs_earnings.nonprofit_org_id) #{cols}", :conditions => ['created_at BETWEEN ? AND ?', Time.now.beginning_of_year, Date.today.end_of_year]}
    named_scope :last_year, { :select => "DISTINCT ON (nonprofit_orgs_earnings.nonprofit_org_id) #{cols}", :conditions => ['created_at BETWEEN ? AND ?', Time.now.last_year.beginning_of_year, Time.now.last_year.end_of_year]}
  else
    named_scope :today, { :group => :nonprofit_org_id, :conditions => ['created_at BETWEEN ? AND ?', Time.now.beginning_of_day, Time.now.end_of_day]}
    named_scope :this_week, { :group => :nonprofit_org_id, :conditions => ['created_at BETWEEN ? AND ?', Time.now.beginning_of_week, Time.now.end_of_week]}
    named_scope :last_week, { :group => :nonprofit_org_id, :conditions => ['created_at BETWEEN ? AND ?', 1.week.ago.beginning_of_week, 1.week.ago.end_of_week]}
    named_scope :this_month, { :group => :nonprofit_org_id, :conditions => ['created_at BETWEEN ? AND ?', Time.now.beginning_of_month, Time.now.end_of_month]}
    named_scope :last_month, { :group => :nonprofit_org_id, :conditions => ['created_at BETWEEN ? AND ?', Time.now.last_month.beginning_of_month, Time.now.last_month.end_of_month]}
    named_scope :this_quarter, { :group => :nonprofit_org_id, :conditions => ['created_at BETWEEN ? AND ?', Time.now.beginning_of_quarter, Time.now.end_of_quarter]}
    named_scope :last_quarter, { :group => :nonprofit_org_id, :conditions => ['created_at BETWEEN ? AND ?', @last_quarter_stat, Time.now.beginning_of_quarter]}
    named_scope :this_year, { :group => :nonprofit_org_id, :conditions => ['created_at BETWEEN ? AND ?', Time.now.beginning_of_year, Date.today.end_of_year]}
    named_scope :last_year, { :group => :nonprofit_org_id, :conditions => ['created_at BETWEEN ? AND ?', Time.now.last_year.beginning_of_year, Time.now.last_year.end_of_year]}
  end
  
  validates_presence_of :nonprofit_org_id
  validates_presence_of :survey_id
  validates_presence_of :user_id
  validates_presence_of :amount_earned
  validates_presence_of :amount_donated_by_user
  
end

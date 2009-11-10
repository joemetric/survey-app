class Reply < ActiveRecord::Base
  
  belongs_to :survey
  belongs_to :user
  
  has_many :answers
#  Since transfer of total payout amount through Paypal
#  can fail so more than one attempts can be made hence reply has_many transfers
  has_many :transfers 
  
  validates_presence_of :user_id, :survey_id
  validates_uniqueness_of :user_id, :scope => "survey_id"
  
  accepts_nested_attributes_for :answers
  
  named_scope :by_user, lambda { |u| { :conditions => { :user_id => u.id }}}
  
  def complete?
    (survey.questions.size == answers.size)    
  end
  
  def total_payout # Returns sum of rewards for answering all questions of survey
    complete? ? reward_for_all_answers : 0.00
  end
  
  def reward_for_all_answers
    sum_of_rewards = 0.00
    answers.each {|a| sum_of_rewards += a.reward}
    sum_of_rewards
  end

end

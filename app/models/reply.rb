# == Schema Information
# Schema version: 20091110082101
#
# Table name: replies
#
#  id         :integer(4)      not null, primary key
#  survey_id  :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  paid       :boolean(1)
#

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
  
  def answers_with_question_type
    answers.all(:select => 'answers.*, questions.question_type_id AS question_type_id',
                 :joins => ['INNER JOIN questions ON answers.question_id = questions.id'])
  end
  
  def complete?
    (survey.questions.size == answers.size)    
  end
  
  def have_answer?
    !answers.size.zero?
  end
  
  def completed_at
    last_answer.created_at if complete?
  end
  
  def total_payout # Returns sum of rewards for answering all questions of survey
    complete? ? reward_for_all_answers : 0.00
  end
  
  def last_answer
    last, time = nil, created_at
    answers.each { |answer| last, time = answer, answer.created_at if (answer.created_at > time) }
    last
  end
    
  def reward_for_all_answers
    sum_of_rewards = 0.00
    answers.each {|a| sum_of_rewards += a.reward}
    sum_of_rewards
  end
  
  def to_json(options = {})
    options.merge!(:methods => [ :completed_at ])
    super
  end

end

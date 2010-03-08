# == Schema Information
# Schema version: 20100308160716
#
# Table name: replies
#
#  id           :integer(4)      not null, primary key
#  survey_id    :integer(4)
#  user_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  status       :string(255)     default("incomplete")
#  completed_at :datetime
#

class Reply < ActiveRecord::Base
  
  ActiveRecord::Base.send(:extend, ConcernedWith)
  
  include AASM
  concerned_with :reply_state_machine
  
  belongs_to :survey
  belongs_to :user
  has_many   :answers
  has_one    :transfer
  
  validates_presence_of :user_id, :survey_id
  validates_uniqueness_of :user_id, :scope => "survey_id"
  
  accepts_nested_attributes_for :answers
  
  named_scope :by_user, lambda { |u| { :conditions => { :user_id => u.id }}}
  named_scope :paid_or_complete,{ :conditions => ["status in (?,?)", "paid", "complete" ]}
  
  def validate_on_create
    if survey.reached_max_respondents? || survey.expired?
      errors.add_to_base('You cannot take this survey. It has expired.')
    end
  end
  
  def answers_with_question_type
    answers.all(:select => 'answers.*, questions.question_type_id AS question_type_id',
                 :joins => ['INNER JOIN questions ON answers.question_id = questions.id'])
  end
  
  ['incomplete', 'complete', 'paid'].each do |s|
    
    named_scope s.to_sym, {:conditions => {:status => s}}
    
    define_method "#{s}?" do
      status == s
    end
  end
  
  def paid
    paid?
  end
  
  def is_final?
    survey.reached_max_respondents?
  end
  
  def all_answers_given?
    survey.questions.size == answers.size
  end
  
  def have_answer?
    !answers.size.zero?
  end
  
  def completed_at
    last_answer.created_at if last_answer && complete?
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
  
  def set_status # This method is invoked from lib/tasks/set_reply_status.rake
    transfer.try(:complete?) ? paid! : (all_answers_given? ? complete! : incomplete!)
  end

end

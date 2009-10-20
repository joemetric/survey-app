class Answer < ActiveRecord::Base
  
  belongs_to :reply
  belongs_to :question
  
  validates_uniqueness_of :question_id, :scope => "reply_id"
  validates_presence_of :answer  
  
  named_scope :by_question, lambda { |q| { :conditions => { :question_id => q.id }}}
    
end

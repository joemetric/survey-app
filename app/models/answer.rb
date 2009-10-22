class Answer < ActiveRecord::Base
  
  has_attached_file :image
  
  belongs_to :reply
  belongs_to :question
  
  validates_uniqueness_of :question_id, :scope => "reply_id"
  validates_presence_of :answer  
  validates_attachment_content_type :image, :content_type => [ "image/gif", "image/jpeg", "image/png" ]
  
  named_scope :by_question, lambda { |q| { :conditions => { :question_id => q.id }}}
    
end

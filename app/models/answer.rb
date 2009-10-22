class Answer < ActiveRecord::Base
  
  has_attached_file :image
  
  belongs_to :reply
  belongs_to :question
  
  validates_uniqueness_of :question_id, :scope => "reply_id"
  validates_presence_of :answer  
  validates_attachment_content_type :image, :content_type => [ "image/gif", "image/jpeg", "image/png" ]
  validate :presence_of_file_only_if_allowed
  
  named_scope :by_question, lambda { |q| { :conditions => { :question_id => q.id }}}
  
  private
  
  def presence_of_file_only_if_allowed
    if QuestionType.accept_files.include?(question.question_type)
      errors.add(:file, "is required") if image_file_name.blank?
    else
      errors.add(:file, "can't be accepted") if image_file_name.exists?
    end
  end
    
end

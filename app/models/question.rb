class Question < ActiveRecord::Base

  belongs_to :survey
  belongs_to :question_type
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :survey_id

end

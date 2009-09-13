class QuestionType < ActiveRecord::Base
  
  FIELD_TYPES = [ "text_field", "text_area", "select_field", "check_box", "file_field" ]
  
  validates_presence_of :name, :field_type
  validates_uniqueness_of :name
  
end

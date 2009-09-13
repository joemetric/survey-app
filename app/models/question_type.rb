class QuestionType < ActiveRecord::Base
    
  FieldTypes = [ "text_field", "text_area", "select_field", "check_box", "file_field" ]
  
  validates_presence_of :name, :field_type
  validates_inclusion_of :field_type, :in => FieldTypes
  validates_uniqueness_of :name
  
  has_many :questions
  
end

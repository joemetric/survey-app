# == Schema Information
# Schema version: 20091008131247
#
# Table name: question_types
#
#  id                       :integer(4)      not null, primary key
#  name                     :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  field_type               :string(255)
#  package_question_type_id :integer(4)
#

class QuestionType < ActiveRecord::Base
    
  FieldTypes = [ "text_field", "text_area", "select_field", "check_box", "file_field" ]
  
  validates_presence_of :name, :field_type
  validates_inclusion_of :field_type, :in => FieldTypes
  validates_uniqueness_of :name
  
  belongs_to :package_question_type
  has_many :questions
  
end

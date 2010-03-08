# == Schema Information
# Schema version: 20100308160716
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
  
  PackageQuestionTypes = {
                          '1' => 1,  # question_type_id => package_question_type_id
                          '2' => 1,
                          '3' => 2
                          }
  
  validates_presence_of :name, :field_type
  validates_inclusion_of :field_type, :in => FieldTypes
  validates_uniqueness_of :name
  
  belongs_to :package_question_type
  has_many :questions
  
  named_scope :accept_files, { :conditions => { :field_type => "file_field" } }
  
  def valid_name
    name.downcase.gsub(" ", "_")
  end
  
end

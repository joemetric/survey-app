# == Schema Information
# Schema version: 20091012054719
#
# Table name: questions
#
#  id               :integer(4)      not null, primary key
#  created_at       :datetime
#  updated_at       :datetime
#  survey_id        :integer(4)
#  name             :string(255)
#  question_type_id :integer(4)
#

class Question < ActiveRecord::Base

  belongs_to :survey
  belongs_to :question_type
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :survey_id
  
  def options=(options_attributes)
    self.complement = options_attributes.split(",")
  end
  
  def options
    complement.blank? ? "" : complement.join(",")
  end

  serialize :complement, Array
  
  def question_type_name
    question_type.name
  end
  
end
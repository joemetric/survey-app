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
  
  def text; name end
  
end

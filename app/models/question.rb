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

  has_many :answers

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :survey_id

  attr_accessor :answer_by_user

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

  def to_json(options = {})
    self.answer_by_user = survey.replies.by_user(options[:user]).first.answers.by_question(self).first if options[:user]
    options.merge!(:methods => [:question_type_name, :answer_by_user])
    super
  end
end

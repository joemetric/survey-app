# == Schema Information
# Schema version: 20091012054719
#
# Table name: answers
#
#  id            :integer(4)      not null, primary key
#  question_id   :integer(4)
#  user_id       :integer(4)
#  question_type :string(255)
#  answer_string :text
#  answer_file   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  picture_id    :integer(4)
#

class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  belongs_to :picture
end

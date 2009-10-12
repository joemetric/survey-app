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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Answer do  # Replace this with your real tests.
  it "should test true" do
    true
  end
end

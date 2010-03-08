# == Schema Information
# Schema version: 20100308160716
#
# Table name: package_question_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  info       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PackageQuestionType < ActiveRecord::Base

  has_many :payouts
  has_many :pricings, :class_name => 'PackagePricing'
  has_many :packages, :through => :pricings
  
  has_many :question_types
  
end

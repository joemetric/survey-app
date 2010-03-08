# == Schema Information
# Schema version: 20100308160716
#
# Table name: payouts
#
#  id                       :integer(4)      not null, primary key
#  package_id               :integer(4)
#  package_question_type_id :integer(4)
#  amount                   :float
#  created_at               :datetime
#  updated_at               :datetime
#

class Payout < ActiveRecord::Base
  
  belongs_to :package
  belongs_to :package_question_type
  
  has_many :survey_payouts
  has_many :surveys, :through => :survey_payouts
  
  validates_presence_of :amount
  
  validates_numericality_of :amount, 
                            :greater_than_or_equal_to => 0,
                            :only_integer => false,
                            :if => Proc.new {|a| !a.amount.blank?}
  
end

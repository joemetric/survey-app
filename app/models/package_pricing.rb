# == Schema Information
# Schema version: 20100308160716
#
# Table name: package_pricings
#
#  id                       :integer(4)      not null, primary key
#  package_id               :integer(4)
#  package_question_type_id :integer(4)
#  total_questions          :integer(4)
#  standard_price           :float
#  normal_price             :float
#  created_at               :datetime
#  updated_at               :datetime
#

class PackagePricing < ActiveRecord::Base
  
  belongs_to :package
  belongs_to :package_question
  
  has_many :survey_pricings
  has_many :surveys, :through => :survey_pricings
  
  validates_presence_of :package_id, :package_question_type_id, :total_questions, :standard_price, :normal_price
   
  validates_numericality_of :total_questions,
                            :only_integer => true,
                            :if => Proc.new {|t| !t.total_questions.blank?}
  
  validates_numericality_of :standard_price,
                            :only_integer => false,
                            :if => Proc.new {|s| !s.standard_price.blank? && s.total_questions > 0}
                            
  
  validates_numericality_of :normal_price, 
                            :greater_than => 0,
                            :only_integer => false,
                            :if => Proc.new {|n| !n.normal_price.blank?}                            
  
end

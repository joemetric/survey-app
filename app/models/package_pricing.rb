class PackagePricing < ActiveRecord::Base
  
  belongs_to :package
  belongs_to :package_question
  
  validates_presence_of :package_id, :package_question_type_id, :total_questions, :standard_price, :normal_price
  
  # TODO - Piyush - Check If following validation blocks can be reduced.
  
  validates_numericality_of :total_questions, 
                            :greater_than => 0,
                            :only_integer => true,
                            :if => Proc.new {|t| !t.total_questions.blank?}
  
  validates_numericality_of :standard_price,
                            :greater_than => 0,
                            :only_integer => false,
                            :if => Proc.new {|s| !s.standard_price.blank?}
                            
  
  validates_numericality_of :normal_price, 
                            :greater_than => 0,
                            :only_integer => false,
                            :if => Proc.new {|n| !n.normal_price.blank?}                            
                              

  
end

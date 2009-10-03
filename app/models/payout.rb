class Payout < ActiveRecord::Base
  
  belongs_to :package
  belongs_to :package_question_type
  
  validates_presence_of :amount
  
  validates_numericality_of :amount, 
                            :greater_than => 0,
                            :only_integer => false,
                            :if => Proc.new {|a| !a.amount.blank?}
  
end

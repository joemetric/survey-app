class PackageQuestionType < ActiveRecord::Base
  
  has_many :payouts
  has_many :pricings, :class => 'PackagePricing'
  has_many :packages, :through => :pricings
  
end

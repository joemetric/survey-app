class Package < ActiveRecord::Base
  
  validates_presence_of :name, :code
  validates_presence_of :base_cost, :on => :update
  validates_uniqueness_of :name, :if => Proc.new{|n| !n.blank? }
  validates_length_of :name, :within => 2..255, :if => Proc.new{|n| !n.blank? }
  validates_length_of :code, :within => 2..255, :if => Proc.new{|c| !c.blank? }
  
  validates_format_of :code, :with => /^[\S]*$/, :if => Proc.new{|c| !c.blank? }
  
  validates_numericality_of :base_cost,
                            :greater_than => 0,
                            :only_integer => true,
                            :if => Proc.new {|b| !b.base_cost.blank?},
                            :on => :update
  
  has_many :payouts
  has_many :pricings, :class_name => 'PackagePricing'
  has_many :package_question_types, :through => :pricings

  def before_validation
    write_attribute(:code, code.strip)
  end
  
  def pricings_and_payouts_valid?(params)
    returning payouts_pricing_errors = [] do 
      ['pricings', 'payouts'].each do |p|
        params[p].each_pair { |key, value|
          record = self.send(p).new(value.merge!({:package_question_type_id => key}))
          payouts_pricing_errors << record.errors.full_messages if record.invalid?
        }
      end
    end
  end
  
  def save_pricing_and_payouts(params)
    ['pricings', 'payouts'].each do |p|
      send(p).delete_all
      params[p].each_pair {|key, value| self.send(p).create(value.merge!({:package_question_type_id => key}))}
    end
  end
  
end

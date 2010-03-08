# == Schema Information
# Schema version: 20100308160716
#
# Table name: packages
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  code            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  base_cost       :float
#  total_responses :integer(4)
#

class Package < ActiveRecord::Base
  
  validates_presence_of :name, :code
  validates_presence_of :base_cost, :on => :update
  validates_uniqueness_of :name, :if => Proc.new{|n| !n.blank? }
  validates_length_of :name, :within => 2..255, :if => Proc.new{|n| !n.blank? }
  validates_length_of :code, :within => 2..255, :if => Proc.new{|c| !c.blank? }
  
  validates_format_of :code, :with => /^[\S]*$/, :if => Proc.new{|c| !c.blank? }
  
  validates_numericality_of :base_cost,
                            :only_integer => false,
                            :if => Proc.new {|b| !b.base_cost.blank?},
                            :on => :update
  
  validates_numericality_of :total_responses,
                            :only_integer => true,
                            :greater_than => 0, :on => :update
  
                             
  has_one :lifetime, :class_name => 'PackageLifetime'
  has_many :payouts
  has_many :pricings, :class_name => 'PackagePricing'
  has_many :package_question_types, :through => :pricings
  
  accepts_nested_attributes_for :lifetime
  
  after_create :create_lifetime
  
  def create_lifetime
    PackageLifetime.create(:package_id => id, :cancelled => false, :validity_type_id => 1)
  end
  
  def self.default
    find_by_code('default')
  end
  
  def before_validation
    write_attribute(:code, code.strip)
  end
  
  def self.default_package; find(:first) end
  
  def new_package?
    lifetime.blank? || payouts.blank? || pricings.blank?
  end
  
  def self.load_package(package_name)
    if package_name
      requested_package = package_in_question(package_name)
      requested_package.new_package? ? default_package : requested_package
    else
      default_package
    end
  end
  
  def self.package_in_question(package_name)
    package_name ? find_by_name(package_name) : default_package
  end
  
  def self.valid_packages
    all.collect {|p| p if p.valid_package?}.compact
  end
  
  def valid_package?
    total_count = lifetime.total_uses || 0
    validity_type = lifetime.validity_type_id
    case validity_type
      when 1; !lifetime.cancelled 
      when 2; Survey.all.count {|s| s.package_id == id} < total_count
      when 3; Date.today.between?(lifetime.valid_from, lifetime.valid_until)
    end
  end
  
  def pricing_info
    pricings.find(:all, 
                  :select => ['package_pricings.*, package_question_types.*'],
                  :joins => ['LEFT JOIN package_question_types ON package_pricings.package_question_type_id = package_question_types.id'],
                  :order => 'package_question_types.id ASC')
  end
  
  def payout_info
    payouts.find(:all, 
                 :select => ['payouts.*, package_question_types.*'],
                 :joins => ['LEFT JOIN package_question_types ON payouts.package_question_type_id = package_question_types.id'],
                 :order => 'package_question_types.id ASC')
  end
  
  def questions_info
    returning questions = [] do 
      pricing_info.each {|i| questions << "#{i.name.plural_form(i.total_questions)}(#{i.info})"}
    end
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
  
  def cancel
    lifetime.cancelled = true
    lifetime.validity_type_id = 1
    lifetime.save
  end 
  
end



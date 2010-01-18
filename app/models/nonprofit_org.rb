# == Schema Information
# Schema version: 20100111122245
#
# Table name: nonprofit_orgs
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  address1      :string(255)
#  city1         :string(100)
#  state1        :string(100)
#  zipcode1      :string(100)
#  address2      :string(255)
#  city2         :string(100)
#  state2        :string(100)
#  zipcode2      :string(100)
#  phone         :string(100)
#  email         :string(100)
#  tax_status    :string(100)
#  tax_id        :integer(4)
#  contact_name  :string(255)
#  contact_phone :string(100)
#  website       :string(255)
#  description   :text
#  notes         :text
#  active        :boolean(1)
#  created_at    :datetime
#  updated_at    :datetime
#

class NonprofitOrg < ActiveRecord::Base
  
  validates_presence_of :name
  validates_length_of :name, :within => 2..255, :if => Proc.new{|org| !org.blank? }
  validates_numericality_of :zipcode1, :if => Proc.new { |org| !org.zipcode1.blank? }
  validates_numericality_of :zipcode2, :if => Proc.new { |org| !org.zipcode2.blank? }
  validates_numericality_of :tax_id, :if => Proc.new { |org| !org.tax_id.blank? }
  
  def get_organization_basedon_status(status)
    find(:all, :conditions => ['active >= ?', status])
  end
end

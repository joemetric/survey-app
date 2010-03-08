# == Schema Information
# Schema version: 20100308160716
#
# Table name: locations
#
#  id            :integer(4)      not null, primary key
#  owner_id      :integer(4)
#  owner_type    :string(255)
#  name          :string(255)
#  address_line1 :string(255)
#  address_line2 :string(255)
#  city          :string(255)
#  state         :string(255)
#  zipcode       :string(255)
#  country       :string(255)     default("AMERRRRICA! FUCK YYEEAAH!")
#  created_at    :datetime
#  updated_at    :datetime
#

class Location < ActiveRecord::Base
  OrderedAttributes = %w( country state city zipcode )

  belongs_to :owner, :polymorphic => true 

  validates_presence_of :name, :owner
  validates_presence_of :state, :if => :city?

  def within? other_location
    OrderedAttributes.all? do |attr| 
      other_location.send(attr).nil? || send(attr) == other_location.send(attr)
    end
  end

end

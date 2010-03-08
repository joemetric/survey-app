# == Schema Information
# Schema version: 20100308160716
#
# Table name: nonprofit_orgs
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  address1          :string(255)
#  city1             :string(100)
#  state1            :string(100)
#  zipcode1          :string(100)
#  address2          :string(255)
#  city2             :string(100)
#  state2            :string(100)
#  zipcode2          :string(100)
#  phone             :string(100)
#  email             :string(100)
#  tax_status        :string(100)
#  tax_id            :integer(4)
#  contact_name      :string(255)
#  contact_phone     :string(100)
#  website           :string(255)
#  description       :text
#  notes             :text
#  active            :boolean(1)
#  created_at        :datetime
#  updated_at        :datetime
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer(4)
#  logo_updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NonprofitOrg do
  fixtures :nonprofit_orgs
  
  before(:each) do
    @organization = NonprofitOrg.new(valid_attributes)
  end

  context "Validate Attributes" do
    should_validate_presence_of :name
    should_validate_presence_of :address1
    should_validate_presence_of :city1
    should_validate_presence_of :state1
    should_validate_presence_of :zipcode1
    should_validate_presence_of :phone
    should_validate_presence_of :email
    should_validate_presence_of :tax_status
    should_validate_presence_of :tax_id
    
    should_validate_uniqueness_of :tax_id, :if => Proc.new { |org| !org.tax_id.blank? }
    
    should_validate_numericality_of :zipcode1, :if => Proc.new { |org| !org.zipcode1.blank? }
    should_validate_numericality_of :zipcode2, :if => Proc.new { |org| !org.zipcode2.blank? }
    should_validate_numericality_of :phone, :if => Proc.new { |org| !org.phone.blank? }
    should_validate_numericality_of :tax_id, :only_integer => true, :if => Proc.new { |org| !org.tax_id.blank? }
    should_validate_numericality_of :contact_phone, :if => Proc.new { |org| !org.contact_phone.blank? }
    
    should_validate_length_of :name, :within => 2..255, :if => Proc.new { |org| !org.name.blank? }
    should_validate_length_of :zipcode1, :is => 5, :if => Proc.new { |org| !org.zipcode1.blank? }
    should_validate_length_of :zipcode2, :is => 5, :if => Proc.new { |org| !org.zipcode2.blank? }
    should_validate_length_of :phone, :is => 10, :if => Proc.new { |org| !org.phone.blank? }
    should_validate_length_of :contact_phone, :is => 10, :if => Proc.new { |org| !org.contact_phone.blank? }

    it "All entries should be valid" do
      @organization.valid?.should be(true)
    end
    
  end
  
  private
  
  def valid_attributes
    { "name" => "Testing Organization Created", 
      "address1" => "Testing Organization Address One",
      "city1" => "Testing Organization City One", 
      "state1" => "CA", 
      "zipcode1"=> "12345", 
      "address2" => "Testing Organization Address Two",
      "city2" => "Testing Organization City Two", 
      "state2" => "CA", 
      "zipcode2"=> "45678",
      "phone" => "1234567890",
      "email" => "testingorg@domain.com",
      "tax_status" => "Approved",
      "tax_id" => 324377,
      "contact_name" => "Testing Contact Person Name",
      "contact_phone" => "1234548292",
      "website" => "http://www.testingorgdomain.com",
      "description" => "Testing Organization Description",
      "notes" => "Testing Organization Notes"
    }
  end
  
end

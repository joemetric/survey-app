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

#require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
#
#describe Location do
#  
#  context "validations" do
#    should_belong_to :owner
#    should_require_attributes :name, :owner
#  end
#
#  context "API for Demographic" do
#    
#    @location = Location.new
#    
#    context "when checking whether this location is within another" do
#      
#        @other_location = Location.new
#
#        @location.zipcode = '43212'
#        @location.city = 'Columbus'
#        @location.state = 'OH'
#        @location.country = 'US of A'
#    
#      it "should not be within the other when the countries are not equal" do
#        @other_location.country = "Not US of A"
#        #assert !@location.within?(@other_location)
#        @location.within?(@other_location).should_be false
#      end
#
#      it "should be within the other when its country is nil" do
#        @other_location.country = nil
#        @location.within?(@other_location).should_be true
#      end
#
#      context "when the countries are equal" do
#        
#          @other_location.country = 'US of A'
#    
#        it "should not be within when the states are not equal" do
#          @other_location.state = 'MA'
#          @location.within?(@other_location).should_be false
#        end
#
#        it "should be within the other when its state is nil" do
#          @other_location.state = nil
#          @location.within?(@other_location).should_be true
#        end
#        
#        context "and the states are equal" do
#          
#            @other_location.state = 'OH'
#          
#          it "should not be within when the cities are not equal" do
#            @other_location.city = 'Cleveland'
#            @location.within?(@other_location).should_be false
#          end
#
#          it "should be within when the other city is nil" do
#            @other_location.city = nil
#            @location.within?(@other_location).should_be true
#          end
#
#          context "and the cities are equal" do
#            
#              @other_location.city = 'Columbus'
#
#            it "should not be within when the zipcodes are not equal" do
#              @other_location.zipcode = '44122'
#              @location.within?(@other_location).should_be false
#            end
#
#            it "should be within when the other zipcode is nil" do
#              @other_location.zipcode = nil
#              @location.within?(@other_location).should_be true
#            end
#
#          end
#        end
#      end
#    end
#  end
#end

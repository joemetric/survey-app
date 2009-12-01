# == Schema Information
# Schema version: 20091127040223
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  login             :string(40)
#  name              :string(100)     default("")
#  email             :string(100)
#  crypted_password  :string(40)
#  created_at        :datetime
#  updated_at        :datetime
#  birthdate         :date
#  gender            :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  perishable_token  :string(255)
#  active            :boolean(1)
#  type              :string(255)     default("User")
#  income_id         :integer(4)
#  zip_code          :string(255)
#  blacklisted       :boolean(1)
#

class User < ActiveRecord::Base

  Income = Incomes = {
    0 => "Under $15,000",
    1 => "$15,000 - $24,999", 2 => "$25,000 - $29,999",
    3 => "$30,000 - $34,999", 4 => "$35,000 - $39,999",
    5 => "$40,000 - $44,999", 6 => "$45,000 - $49,999",
    7 => "$50,000 - $59,999",
    8 => "$60,000 - $74,999", 9 => "$75,000 - $99,999",
    10 => "$100,000 - $149,999", 11 => "$150,000 - $199,999",
    12 => "$200,000 or more"
  }

  MartialStatus = {
    1 => 'Single',
    2 => 'Married',
    3 => 'Widowed',
    4 => 'Divorced'
  }

  # Race Demographics taken from http://projects.allerin.com/attachments/820/mockup_Dashboard_new.png

  Race = {
    1 => 'White/Caucasian',
    2 => 'African-American/Black',
    3 => 'Hispanic/Latino',
    4 => 'Asian',
    5 => 'American Indian/Alaska Native',
    6 => 'Pacific Islander/Native Hawaiian'
  }

  Gender = {
   'male' => 'Male',
   'female' => 'Female'
  }

  Occupation = {
    1 => 'Executive/Upper Management',
    2 => 'IT/MIS Professional',
    3 => 'Doctor/Surgeon',
    4 => 'Educator',
    5 => 'Small Business Owner',
    6 => 'Homemaker',
    7 => 'Student',
    8 => 'None of the Above'
  }

  Education = {
    1 => 'Completed Some High School',
    2 => 'High School Graduate',
    3 => 'Completed Some College',
    4 => 'College Degree',
    5 => 'Completed Some Postgraduate',
    6 => 'Master\'s Degree',
    7 => 'Doctorate, Law or Professional Degree'
  }

  Demographics = [:gender, :income, :martial_status, :race, :education, :occupation]

  def self.demographic_data(params, group_by_column)
    find(:all,
      :select => "users.*, #{params[:filter_column]} as filter_id, COUNT(#{params[:filter_column]}) AS count",
      :conditions => ["#{params[:filter_column]} IS NOT NULL"],
      :group => "#{group_by_column} ASC",
      :order => "#{params[:filter_column]} ASC" )
  end

  def income=(income_string)
    self.income_id = Incomes.invert[income_string]
  end

  def income
    Incomes[income_id]
  end

  def race=(race_string)
    self.race_id = Race.invert[race_string]
  end

  def race
    Race[race_id]
  end

  def martial_status=(martial_string)
    self.martial_status_id = MartialStatus.invert[martial_string]
  end

  def martial_status
    MartialStatus[martial_status_id]
  end

  def education
    Education[education_id]
  end

  def occupation
    Occupation[occupation_id]
  end
end

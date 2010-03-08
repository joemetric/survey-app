# == Schema Information
# Schema version: 20100308160716
#
# Table name: survey_packages
#
#  id              :integer(4)      not null, primary key
#  survey_id       :integer(4)
#  name            :string(255)
#  code            :string(255)
#  base_cost       :float
#  total_responses :integer(4)
#

class SurveyPackage < ActiveRecord::Base
  
  belongs_to :survey
  
  def self.copy_package(survey, package)
    survey_package = SurveyPackage.new
    survey_package.survey_id = survey.id
    survey_package.name = package.name
    survey_package.code = package.code
    survey_package.base_cost = package.base_cost
    survey_package.total_responses = package.total_responses
    survey_package.save
  end
  
  def questions_info
    returning questions = [] do 
      survey.pricing_data.each {|i| questions << "#{i.name.plural_form(i.total_questions)}(#{i.info})"}
    end
  end
  
end

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
  
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SurveyHelperMethods
end

describe Survey do
  include SurveyHelperMethods
  fixtures :survey
  
end
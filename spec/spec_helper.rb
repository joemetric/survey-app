ENV["RAILS_ENV"] ||= 'development'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'
require 'remarkable'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Spec::Runner.configure do |config|
  config.include Webrat::Matchers, :type => :views
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end

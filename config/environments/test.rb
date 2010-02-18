# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Configure App Address
HOST = "localhost"

config.gem 'rspec-rails', :version => '>= 1.3.2', :lib => false unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))

config.after_initialize do 
  ActiveMerchant::Billing::Base.gateway_mode = :test
  ::GATEWAY = ActiveMerchant::Billing::Base.gateway(:paypal_express).new(:login => "dev_1252207951_biz_api1.joemetric.com", 
                                                                       :password => "QY557JKYHNW5D5ZQ",
                                                                       :signature => "AbmqUIwrIt8wU2gVWKdQdoCuN1bWAb9FQERQS0OSCvpgJou-rCTkYq54")
end
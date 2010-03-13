# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# Configure App Address
HOST = "localhost:3000"

require 'ruby-debug'

config.after_initialize do 
  ActiveMerchant::Billing::Base.gateway_mode = :test
  ::GATEWAY = ActiveMerchant::Billing::Base.gateway(:paypal_express).new(:login => "dev_1252207951_biz_api1.joemetric.com", 
                                                                       :password => "QY557JKYHNW5D5ZQ",
                                                                       :signature => "AbmqUIwrIt8wU2gVWKdQdoCuN1bWAb9FQERQS0OSCvpgJou-rCTkYq54")
end
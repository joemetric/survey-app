RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.gem "authlogic"
  config.gem "rspec", :lib => false
  config.gem "rspec-rails", :lib => false
  config.gem "giraffesoft-resource_controller", :lib => 'resource_controller', :source => 'http://gems.github.com'
  config.gem "jscruggs-metric_fu", :lib => "metric_fu", :source => "http://gems.github.com"
  config.gem "haml"
  config.gem "ambethia-smtp-tls", :lib => "smtp-tls", :source => "http://gems.github.com/"    
  config.gem "webrat"
  config.gem "cucumber", :source => "http://gems.github.com"
  config.gem "activemerchant", :lib => "active_merchant"
  config.gem "will_paginate"
  config.gem "chronic"
  config.gem "packet"
  config.gem "thoughtbot-paperclip", :lib => "paperclip", :source => "http://gems.github.com"
  config.gem "money"
  config.gem "factory_girl", :source => "http://gemcutter.org"
  config.gem "aws-s3", :lib => "aws/s3"
  config.gem 'right_aws', :version => '1.10.0'
  config.gem 'prawn'
  
  #Mime::Type.register "application/pdf", :pdf

  # The new rails version (2.3.4) deprecated a config in AR that raises exceptions when you 
  # run rake spec.
  # Carlos already updated on git but not as gem. So the edge version is installed as plugin
  # TODO Remove remarkable plugin and update gem
  #config.gem "carlosbrando-remarkable", :lib => "remarkable", :source => "http://gems.github.com"
  
  config.load_paths += %W( #{RAILS_ROOT}/app/modules )
  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_joemetric_session',
    :secret      => '980822280a99729e2048a23952bb3ca00671249d22563f466bed1eb310a800af7e38753d6ab006b28fb9d9ab40e7fb26a04c8d09291e3f244c087cef7c451c4e'
  }
  
  config.action_mailer.delivery_method = :smtp  
  config.action_mailer.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 25,
  :domain => 'joemetric.com',
  :user_name => 'noreply@joemetric.com',
  :password => 'odd71;humble',
  :authentication => :plain
  }
  
  #config.after_initialize do 
   # ActiveMerchant::Billing::Base.gateway_mode = :test
    #::GATEWAY = ActiveMerchant::Billing::Base.gateway(:paypal_express).new(:login => "dev_1252207951_biz_api1.joemetric.com", 
     #                                                                    :password => "QY557JKYHNW5D5ZQ",
      #                                                                   :signature => "AbmqUIwrIt8wU2gVWKdQdoCuN1bWAb9FQERQS0OSCvpgJou-rCTkYq54")
  #end

end

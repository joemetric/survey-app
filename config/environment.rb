RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.gem 'authlogic'
  config.gem 'rspec', :lib => false, :version => '>= 1.2.0'
  config.gem 'rspec-rails', :lib => false, :version => '>= 1.2.0'
  config.gem 'giraffesoft-resource_controller', :lib => 'resource_controller', :source => 'http://gems.github.com'
  config.gem 'jscruggs-metric_fu', :version => '1.1.5', :lib => 'metric_fu', :source => 'http://gems.github.com'
  config.gem 'haml'
  config.gem "ambethia-smtp-tls", :lib => "smtp-tls", :source => "http://gems.github.com/"    

  # Let's try Remarkable instead of Shoulda.
  # Should be better
  config.gem "carlosbrando-remarkable", :lib => "remarkable", :source => "http://gems.github.com"
  # config.gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com'
  
  config.load_paths += %W( #{RAILS_ROOT}/app/modules )
  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_joemetric_session',
    :secret      => '980822280a99729e2048a23952bb3ca00671249d22563f466bed1eb310a800af7e38753d6ab006b28fb9d9ab40e7fb26a04c8d09291e3f244c087cef7c451c4e'
  }
  
  config.action_mailer.delivery_method = :smtp  
  config.action_mailer.smtp_settings = {
    :address        => "smtp.gmail.com",
    :port           => 25,
    :domain         => "gmail.com",
    :authentication => :plain,
    :user_name      => "87621a41@gmail.com",
    :password       => "123survey" 
  }  
  
  
end

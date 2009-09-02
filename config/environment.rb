RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'jscruggs-metric_fu', :version => '1.1.5', :lib => 'metric_fu', :source => 'http://gems.github.com'
  config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
  
  config.load_paths += %W( #{RAILS_ROOT}/app/modules )

  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_joemetric_session',
    :secret      => '980822280a99729e2048a23952bb3ca00671249d22563f466bed1eb310a800af7e38753d6ab006b28fb9d9ab40e7fb26a04c8d09291e3f244c087cef7c451c4e'
  }

  config.active_record.observers = :user_observer # :cacher, :garbage_collector

end

# This file is automatically copied into RAILS_ROOT/initializers

require 'tls_smtp'

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 25,
  :domain => 'joemetric.com',
  :user_name => 'noreply@joemetric.com',
  :password => 'odd71;humble',
  :authentication => :plain
}

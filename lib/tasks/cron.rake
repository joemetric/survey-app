task :cron => :environment do
 if Time.now.hour % 12 == 0 # Run every 12 hours
   puts "Expiring Surveys: Executed At: #{Time.now}"
   Survey.mark_as_epxired
 end
 if Time.now.hour == 0 # Run at Midnight
   puts "Paypal Process: Executed At: #{Time.now}"
   PaypalProcessor.execute
 end
end

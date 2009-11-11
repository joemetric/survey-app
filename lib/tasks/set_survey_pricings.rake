namespace :survey do  
  namespace :db do
    desc "Set Survey Pricing Data"
    task :survey_pricings => :environment do
      Survey.find(:all).each do |s|
        puts "Referencing Pricing Data of Survey - #{s.name}"
        s.save_pricing_info
      end
      puts "Rake task completed successfully."
    end
  end
end
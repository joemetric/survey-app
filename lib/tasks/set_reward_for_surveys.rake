namespace :survey do
  desc "Set Reward Amount for each Survey"
  namespace :temp do
    task :set_reward_amount_for_surveys => :environment do
      surveys = Survey.all
      if surveys.blank?
        puts "No surveys found in database.. No need to run this rake in such cases..."
      else
        puts "Setting Rewards for following surveys"
        surveys.each { |s|
          puts "#{s.name}"
          s.calculate_reward
        }
        puts "Rake task completed successfully."
      end  
    end
  end
end
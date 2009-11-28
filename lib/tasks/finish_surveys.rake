namespace :survey do
  desc "Mark Surveys as finished who received all the responses"
  namespace :temp do
    task :finish_surveys => :environment do
      surveys = Survey.all
      if surveys.blank?
        puts "No surveys found in database.. No need to run this rake in such cases..."
      else
        i = 0
        surveys.each { |s| 
          if s.publish_status == 'published' && s.reached_max_respondents?
            i += 1
            puts s.name
            s.finished!
          end
        }
        puts "#{i} surveys were marked as finished..."
        puts "Rake task completed successfully."
      end  
    end
  end
end
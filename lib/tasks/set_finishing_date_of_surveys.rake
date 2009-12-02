namespace :survey do
  desc "Set finishing of finished surveys"
  namespace :temp do
    task :set_finishing_date_of_surveys => :environment do
      surveys = Survey.all
      if surveys.blank?
        puts "No surveys found in database.. No need to run this rake in such cases..."
      else
        surveys.each { |s| 
          if s.publish_status == 'finished' && s.reached_max_respondents?
            last_answer_at = s.replies.last.answers.last.created_at
            puts "#{s.name} completed at #{last_answer_at}"             
            s.update_attribute(:finished_at, last_answer_at)
          end
        }
        puts "Rake task completed successfully."
      end  
    end
  end
end
namespace :survey do
  desc "Set completion date of every completed reply"
  namespace :temp do
    task :set_completed_at_of_replies => :environment do
      replies = Reply.paid_or_complete
      if replies.blank?
        puts "No Complete Replies found in database.. No need to run this rake in such cases..."
      else
        replies.each { |r| 
          last_answer = r.answers.last
          r.update_attribute(:completed_at, last_answer.created_at) if last_answer
        }
        puts "Rake task completed successfully."
      end  
    end
  end
end
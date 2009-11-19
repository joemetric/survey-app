namespace :survey do
  namespace :db do
    desc "Create Transfer object for existing replies"
    task :create_transfers => :environment do
      existing_replies = Reply.find(:all)
      if existing_replies.blank?
        puts "replies table is empty !!!"
      else
        existing_replies.each { |r| Transfer.find_or_create_for(r) if r.complete? }
        puts "Rake task completed successfully..."
      end
    end
  end
end

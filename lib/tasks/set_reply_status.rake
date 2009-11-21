# This rake task is added for the following reasons:
# 
# Added new column `status` in replies table
# So there's no need of `paid` column
# It was required to set `status` of all the repies depending upon total answers given for reply 
# and value of `paid` column

namespace :survey do
  desc "Set status of existing reply objects"
  task :set_reply_status => :environment do
    replies = Reply.all
    if replies.blank?
      puts '`replies` table is empty. No need run this rake in such cases'
    else
      replies.each {|r| r.set_status}
      puts 'Rake task executed successfully !!!'
    end
  end
end
namespace :survey do
  namespace :db do
    desc "Finish paying uncompleted transfers"
    task :complete_transfers => :environment do
      PaypalProcessor.transfer
    end
  end
end

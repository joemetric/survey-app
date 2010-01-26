namespace :survey do
  namespace :load do
    desc "Builds all tasks related to loading default data"
    task :all => :environment do
      Rake::Task["db:create:all"].invoke
      Rake::Task["db:migrate"].invoke
      Rake::Task["survey:db:default_users"].invoke
      Rake::Task["survey:db:questions_types"].invoke
      Rake::Task["survey:db:default_packages"].invoke
      Rake::Task["survey:db:survey_pricings"].invoke
      Rake::Task["survey:db:create_transfers"].invoke
      Rake::Task["survey:set_reply_status"].invoke
      Rake::Task["survey:temp:finish_surveys"].invoke
      Rake::Task["survey:temp:set_finishing_date_of_surveys"].invoke
      Rake::Task["survey:temp:set_reward_amount_for_surveys"].invoke
      Rake::Task["survey:temp:set_completed_at_of_replies"].invoke
    end
  end
end
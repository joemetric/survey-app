namespace :survey do
  desc "Expire surveys whose end date has passed"
  task :expire_surveys => :environment do
    Survey.mark_as_epxired
  end
end
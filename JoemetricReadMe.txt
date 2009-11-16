Following steps should be performed during application deployment:

****These tasks should be executed in the same sequence as written below****

1) Create Database
rake db:create

2) Migrate table schema to Application Database
rake db:migrate

3) Rake Tasks
rake db:default_users (Load Default Users)
rake db:questions_types (Load Default Questions Types)
rake db:default_packages (Load Default Package Data)
rake db:survey_pricings - (Set Survey Pricing Data - This task is not required if surveys table of app db is empty)

Cron job Configuration:

Following commands are required to executed on hosting server to start cron jobs that will handle periodic refunds
and payout transfers:

1) Start Cron Job

Execute: crontab -e 

Add following entry in crontab file:

0 0 * * 0-6 /usr/bin/ruby APPLICATION_PATH/script/runner -e production PaypalProcessor.execute

2) Restart cron jobs: /etc/init.d/cron restart



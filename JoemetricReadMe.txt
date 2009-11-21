Following steps should be performed during application deployment:

****These tasks should be executed in the same sequence as written below****

1) Create Database
rake db:create

2) Migrate table schema to Application Database
rake db:migrate

3) Rake Tasks

1) rake survey:db:default_users 
Load Default Users

2) rake db:questions_types
Load Default Questions Types

3) rake survey:survey:db:default_packages
Load Default Package Data

4) rake survey:db:survey_pricings 
Set Survey Pricing Data - This task is not required if surveys table of app db is empty

5) rake survey:db:create_transfers
Creates transfer objects for existing replies. Not required when Web app is deployed for the first time.

Cron job Configuration:

1) Prepare Cron Job

Execute: crontab -e 

Add following entries in crontab file:

Handle periodic refunds, payout transfers
* 0,12 * * * *  cd APPLICATION_PATH && rake survey:payment:start_paypal_process RAILS_ENV=production


Expire Surveys
0 0 * * * cd APPLICATION_PATH && rake survey:expire_surveys RAILS_ENV=production


2) Restart cron jobs: /etc/init.d/cron restart



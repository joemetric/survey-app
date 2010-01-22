Following steps should be performed during application deployment:

****These tasks should be executed in the same sequence as written below****

1) Create Database
rake db:create:all

2) Migrate table schema to Application Database
rake db:migrate

3) Rake Tasks

4) rake survey:db:default_users 
Load Default Users

5) rake survey:db:questions_types
Load Default Questions Types

6) rake survey:db:default_packages
Load Default Package Data

7) rake survey:db:survey_pricings 
Set Survey Pricing Data - This task is not required if surveys table of app db is empty

8) rake survey:db:create_transfers
Creates transfer objects for existing replies. Not required when Web app is deployed for the first time.

9) rake survey:set_reply_status
Update status of existing reply objects.  Not required when Web app is deployed for the first time.

10) rake survey:temp:finish_surveys
Update status of existing surveys who has already received MAX responses
Not required when Web app is deployed for the first time.

11) rake survey:temp:set_finishing_date_of_surveys
Updates finished_at column of surveys table
Not required when Web app is deployed for the first time.

12) rake survey:temp:set_reward_amount_for_surveys
Updates reward_amount column of surveys table
Not required when Web app is deployed for the first time.

13) rake survey:temp:set_completed_at_of_replies
Updates completed_at column of replies table
Not required when Web app is deployed for the first time.

Cron job Configuration:

1) Prepare Cron Job

Execute: crontab -e 

Add following entries in crontab file:

Handle periodic refunds, payout transfers
* 0,12 * * * *  cd APPLICATION_PATH && rake survey:payment:start_paypal_process RAILS_ENV=production


Expire Surveys
0 0 * * * cd APPLICATION_PATH && rake survey:expire_surveys RAILS_ENV=production


2) Restart cron jobs: /etc/init.d/cron restart



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

Backgroundrb Configuration:

Following commands are required to executed from app directory to start these processes:

1) ruby script/backgroundrb start e production (Starts backgroundrb process)
2) ruby script/backgroundrb stop e production (Stops backgroundrb process)
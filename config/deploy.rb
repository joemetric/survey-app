default_run_options[:pty] = true
set :application, "survey"
set :deploy_to, "/var/apps/survey"
set :use_sudo, false

set :scm, :git
set :scm_verbose, true
set :repository, "git@github.com:joemetric/survey-app.git"
ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache

set :user, "allerin"

role :web, "www.allerin.com"
role :app, "www.allerin.com", :primary => true
role :db,  "www.allerin.com", :primary => true

after "deploy:update_code", 'database:link'

namespace :database do
  desc "Link database.yml to the current app"
  task :link do
    run "ln -nfs #{shared_path}/system/database.yml #{release_path}/config/database.yml"
  end
end

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

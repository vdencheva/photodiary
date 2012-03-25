require 'bundler/capistrano'

site_domain = 'phd.hno3.org'

set :application,       "photodiary"
set :repository,        "git://github.com/vdencheva/photodiary.git"
set :deploy_to,         "/data/rails/#{application}"
set :branch,            'master'
set :deploy_via,        :remote_cache
set :scm,               :git
set :user,              "pyfmi"
set :use_sudo,          false

role :web, site_domain
role :app, site_domain
role :db,  site_domain, :primary => true

set :normalize_asset_timestamps, false

namespace :deploy do
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/database.yml     #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/secret_token.txt #{release_path}/config/secret_token.txt"
    run "ln -nfs #{shared_path}/uploads          #{release_path}/public/uploads"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

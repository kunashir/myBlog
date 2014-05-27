#require "rvm/capistrano"
#require "bundler/capistrano"

set :repo_url, 'git@github.com:kunashir/transport_auction'
set :application, 'transport'
application = 'transport'
set :branch,          "master"
set :migrate_target,  :current
set :ssh_options,     { :forward_agent => true }

set :rails_env,       "production"
set :deploy_to,       "/home/deployer/sites/transport_auction"
set :normalize_asset_timestamps, false
set :copy_exclude, [".git", "spec"]

set :user,            "deployer"
set :use_sudo,        false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/tmp/pids/unicorn.pid"

role :web,    "deployer@10.41.64.117", :primary => true
role :app,    "deployer@10.41.64.117"
role :db,     "deployer@10.41.64.117"

set :default_stage, "production"
set :rvm1_ruby_version, '2.0.0-p481@transport'
set :rvm_type, :user

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_files, %w{config/database.yml tr.ini}

set :bundle_dir, "/home/deployer/.rvm/gems/ruby-2.0.0@global"
set :default_env, { path: "home/deployer/.rvm/gems/ruby-2.0.0-p353/bin:/home/deployer/.rvm/gems/ruby-2.0.0-p353@global/bin:/home/deployer/.rvm/rubies/ruby-2.0.0-p353/bin:/home/deployer/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games" }

# set :keep_releases, 5

namespace :deploy do

  task :precompile do
    on roles(:app) do
      execute "cd #{release_path}/ && RAILS_ENV=production bundle exec rake assets:precompile --trace"
    end
  end

  task :restart do
    on roles(:app) do
      execute "if [ -f #{:unicorn_pid} ] && [ -e /proc/$(cat #{:unicorn_pid}) ]; then kill -USR2 `cat #{:unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{:unicorn_conf} -E #{:rails_env} -D; fi"
    end
  end
  task :start do
    on roles(:app) do
      execute "bundle exec unicorn -c #{:unicorn_conf} -E #{:rails_env} -D"
    end
  end
  task :stop do
    on roles(:app) do
      execute "if [ -f #{:unicorn_pid} ] && [ -e /proc/$(cat #{:unicorn_pid}) ]; then kill -QUIT `cat #{:unicorn_pid}`; fi"
    end
  end

  after :finishing, 'deploy:cleanup'

end


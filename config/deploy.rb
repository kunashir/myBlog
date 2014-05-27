#require "rvm/capistrano"
#require "bundler/capistrano"
set :assets_role, [:web, :app]
#load 'deploy/assets'

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
set :rvm_ruby_version, '2.0.0-p353@global'
set :rvm_type, :user

set :default_env, { rvm_bin_path: '~/.rvm/bin' }
SSHKit.config.command_map[:rake] = "#{fetch(:default_env)[:rvm_bin_path]}/rvm ruby-#{fetch(:rvm_ruby_version)} do bundle exec rake"

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
#set :linked_dirs, %w{bin /home/deployer/.rvm/gems/ruby-2.0.0-p353@global}
set :linked_files, %w{config/database.yml tr.ini}

set :bundle_dir, "/home/deployer/.rvm/gems/ruby-2.0.0-p353@global/bin"
#set :default_env, { path: "home/deployer/.rvm/gems/ruby-2.0.0-p353/bin:/home/deployer/.rvm/gems/ruby-2.0.0-p353@global/bin:/home/deployer/.rvm/rubies/ruby-2.0.0-p353/bin:/home/deployer/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games" }

# set :keep_releases, 5

namespace :deploy do

  task :precompile do
    on roles(:app) do
      within release_path do
        execute :bundle, "exec rake assets:precompile RAILS_ENV=production"
      end
    end
  end

  task :restart do
    on roles(:app) do
      execute "if [ -f #{fetch(:unicorn_pid)} ] && [ -e /proc/$(cat #{fetch(:unicorn_pid)}) ]; then kill -USR2 `cat #{fetch(:unicorn_pid)}`; else cd #{fetch(:deploy_to)}/current && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rails_env)} -D; fi"
    end
  end
  task :start do
    on roles(:all) do
      #execute "cd #{release_path}"
      #set :bundle_dir, "/home/deployer/.rvm/gems/ruby-2.0.0-p353@global"
      within release_path do
        execute :bundle, "exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rails_env)} -D"
      end
    end
  end
  task :stop do
    on roles(:all) do
      execute "if [ -f #{fetch(:unicorn_pid)} ] && [ -e /proc/$(cat #{fetch(:unicorn_pid)}) ]; then kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
    end
  end

  after :finishing, 'deploy:cleanup'
  after :deploy, 'deploy:restart'
end


#require "rvm/capistrano"
#require "bundler/capistrano"
set :assets_role, [:web, :app]
#load 'deploy/assets'

set :repo_url, 'git@bitbucket.org:kunashir/logist_tender.git'
set :application, 'transport'
application = 'transport'
set :branch,          "master"
set :migrate_target,  :current
set :ssh_options,     { :forward_agent => true }

set :rails_env,       "production"
set :deploy_to,       "/home/deployer/apps/logist_tender"
set :normalize_asset_timestamps, false
set :copy_exclude, [".git", "spec"]

set :user,            "deployer"
set :use_sudo,        false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/tmp/pids/unicorn.pid"

role :web,    "deployer@185.5.251.44", :primary => true
role :app,    "deployer@185.5.251.44"
role :db,     "deployer@185.5.251.44"

set :default_stage, "production"
set :rvm_ruby_version, '2.2.2-p95@global'
set :rvm_type, :user
set :pty, true

set :default_env, { rvm_bin_path: '~/.rvm/bin' }
SSHKit.config.command_map[:rake] = "#{fetch(:default_env)[:rvm_bin_path]}/rvm ruby-#{fetch(:rvm_ruby_version)} do bundle exec rake"

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{public/uploads vendor/assets/components}
set :linked_files, %w{config/database.yml config/app.yml config/mail.yml config/recaptcha.yml}

set :bundle_dir, "/home/deployer/.rvm/gems/ruby-2.2.2-p95@global/bin"
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

  task :setup do
    on roles(:all) do
      execute "mkdir  #{shared_path}"
      execute "mkdir  #{shared_path}/config/"
      execute "mkdir  #{deploy_to}/run/"
      execute "mkdir  #{deploy_to}/log/"
      execute "mkdir  #{deploy_to}/socket/"
      execute "mkdir #{shared_path}/system"
      #sudo "ln -s /var/log/upstart #{deploy_to}/log/upstart"

      upload!('config/database.yml', "#{shared_path}/config/database.yml")

      # upload!('config/Procfile', "#{shared_path}/Procfile")


      upload!('config/nginx_ex.conf', "#{shared_path}/nginx_ex.conf")
      sudo 'service nginx stop'
      #sudo "rm -f /usr/local/nginx/conf/nginx.conf"
      sudo "ln -s config/nginx_ex.conf /etc/nginx/sites-enabled/#{application}"
      sudo 'service nginx start'
      #execute "bundle"
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "bundle"
          execute :rake, "db:setup"
          execute :rake, "db:seed"
        end
      end

    end
  end

  task :bower do
    on roles(:app) do
      # upload!('.bowerrc', ".bowerrc")
      upload!('bower.json', "#{deploy_to}/bower.json")
      execute "bower install"
    end
  end

  after :finishing, 'deploy:cleanup'
  after :deploy, 'deploy:restart'
  # before :deploy, 'deploy:bower'
end


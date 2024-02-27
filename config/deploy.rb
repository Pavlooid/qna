# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

set :application, "qna"
set :repo_url, "https://github.com/Pavlooid/qna.git"
set :init_system, :systemd
set :service_unit_name, "sidekiq.service"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

after 'deploy:publishing', 'unicorn:restart'

require 'capistrano_colors'

set :bundle_cmd, '. /etc/profile && bundle'
require "bundler/capistrano"

require 'yaml'
require 'erb'

CONFIG = YAML.load_file('config/config.yml')

set :application, "Image scaler"
set :repository, CONFIG['deploy']['repo']

set :scm, :git
set :deploy_to, CONFIG['base_location']
set :deploy_via, :copy
set :keep_releases, 3
set :use_sudo, false
set :normalize_asset_timestamps, false

set :user, CONFIG['deploy']['ssh_user']
ssh_options[:port] = CONFIG['deploy']['ssh_port']
ssh_options[:keys] = eval(CONFIG['deploy']['ssh_key'])

role :app, CONFIG['deploy']['ssh_host']

after "deploy:update", "deploy:cleanup"
after "deploy:setup", "deploy:more_setup"
after "deploy:finalize_update", "deploy:more_symlinks"

before "deploy:create_symlink",
  "deploy:configs",
  "deploy:nginx_site",
  "deploy:nginx_reload"

namespace :deploy do

  desc 'More setup.. ensure necessary directories exist, etc'
  task :more_setup do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/images"
    run "chmod 2777 #{shared_path}/images"
  end

  desc 'Deploy necessary configs into shared/config'
  task :configs do
    put CONFIG.reject { |x| x == 'deploy' }.to_yaml, "#{shared_path}/config/config.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end

  desc 'Deploy NGiNX site configuration'
  task :nginx_site do
    nginx_config = CONFIG['deploy']['nginx']

    nginx_base_dir = "/etc/nginx"
    nginx_available_dir = "#{nginx_base_dir}/sites-available"
    nginx_enabled_dir = "#{nginx_base_dir}/sites-enabled"
    nginx_available_file = "#{nginx_available_dir}/#{nginx_config['config_name']}"

    put nginx_site_config(nginx_config), nginx_available_file
    run "ln -nsf #{nginx_available_file} #{nginx_enabled_dir}/"
  end

  desc 'Reload NGiNX'
  task :nginx_reload do
    sudo 'service nginx reload'
  end

  desc 'More symlinks'
  task :more_symlinks do
    run "ln -s #{shared_path}/images #{latest_release}/public/images"
  end
end

def nginx_site_config config
  template = ERB.new(File.read('config/nginx-image-scaler.erb'))
  template.result(binding)
end

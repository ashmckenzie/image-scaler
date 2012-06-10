require 'capistrano_colors'

set :bundle_cmd, '. /etc/profile && bundle'
require "bundler/capistrano"

require 'yaml'
require 'erb'

require File.expand_path(File.join('config', 'initialisers', '00_config'))

set :application, "Image Scaler"
set :repository, $CONFIG.deploy.repo

set :scm, :git
set :scm_verbose, true

set :deploy_to, "#{$CONFIG.deploy.base}/#{$APP_CONFIG.name}"
set :deploy_via, :remote_cache

set :keep_releases, 3
set :use_sudo, false
set :normalize_asset_timestamps, false

set :user, $CONFIG.deploy.ssh_user
ssh_options[:port] = $CONFIG.deploy.ssh_port
ssh_options[:keys] = eval($CONFIG.deploy.ssh_key)
ssh_options[:forward_agent] = true

role :app, $CONFIG.deploy.ssh_host

after "deploy:update", "deploy:cleanup"
after "deploy:setup", "deploy:more_setup"

before "deploy:create_symlink",
  "deploy:configs",
  "deploy:nginx_site",
  "deploy:nginx_reload"

namespace :deploy do

  desc 'More setup.. ensure necessary directories exist, etc'
  task :more_setup do
    run "mkdir -p #{shared_path}/config"
  end

  desc 'Deploy necessary configs into shared/config'
  task :configs do
    put $CONFIG.reject { |x| x == 'deploy' }.to_yaml, "#{shared_path}/config/config.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end

  desc 'Deploy NGiNX site configuration'
  task :nginx_site do
    nginx_config = $CONFIG.deploy.nginx

    nginx_base_dir = "/etc/nginx"
    nginx_available_dir = "#{nginx_base_dir}/sites-available"
    nginx_enabled_dir = "#{nginx_base_dir}/sites-enabled"
    nginx_available_file = "#{nginx_available_dir}/#{nginx_config.app_name}"

    put nginx_site_config(nginx_config), nginx_available_file
    run "ln -nsf #{nginx_available_file} #{nginx_enabled_dir}/"
  end

  desc 'Reload NGiNX'
  task :nginx_reload do
    sudo 'service nginx reload'
  end
end

def nginx_site_config config
  template = ERB.new(File.read("config/nginx-#{config.app_name}.erb"))
  template.result(binding)
end
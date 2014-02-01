# encoding: UTF-8

require 'erb'

require File.expand_path(File.join('..', 'config', 'initialise'), __FILE__)

namespace 'image-scaler' do

  desc 'Generage nginx config'
  task :generate_nginx_config do
    nginx_template_file = File.expand_path(File.join('..', 'config', 'deploy', 'image_scaler.nginx.erb'), __FILE__)
    nginx_template = File.read(nginx_template_file)
    puts ERB.new(nginx_template).result(ImageScaler::Config.deploy.nginx.instance_eval { binding })
  end

end

require 'erb'

require File.expand_path(File.join('..', 'config', 'initialise'), __FILE__)

namespace 'image-scaler' do

  desc 'Generage nginx config'
  task :generate_nginx_config do
    template = File.read('/Users/ash/Personal/image-scaler/config/deploy/image_scaler.nginx.erb')
    puts ERB.new(template).result(ImageScaler::Config.deploy.nginx.instance_eval { binding })
  end

end

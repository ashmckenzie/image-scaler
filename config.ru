require 'bundler/setup'
Bundler.require(:default, :development)

require 'sinatra'
require 'fileutils'

if ENV['RACK_ENV'] == 'production'
  log = File.new(File.expand_path("../log/app.log", __FILE__), "a")
  STDOUT.reopen(log)
  STDERR.reopen(log)
end

[ "#{File.dirname(__FILE__)}/cache/rack/meta", "#{File.dirname(__FILE__)}/cache/rack/body" ].each do |dir|
  FileUtils.mkdir_p(dir) unless File.exists?(dir)
end

$ROOT = File.expand_path(File.join(File.dirname(__FILE__)))

require File.join($ROOT, 'app')

use Rack::ConditionalGet
use Rack::ETag
use Stethoscope

set :run, false
run Sinatra::Application
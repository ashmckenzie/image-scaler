require 'rubygems'
require 'sinatra'
require 'fileutils'

[ "#{File.dirname(__FILE__)}/cache/rack/meta", "#{File.dirname(__FILE__)}/cache/rack/body" ].each do |dir|
  FileUtils.mkdir_p(dir) unless File.exists?(dir)
end

$ROOT = File.expand_path(File.join(File.dirname(__FILE__)))

require File.join($ROOT, 'app')

use Rack::ConditionalGet
use Rack::ETag

set :run, false
run Sinatra::Application
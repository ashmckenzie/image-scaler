require 'rubygems'
require 'sinatra'
require 'fileutils'
require 'rack/cache'

[ "#{File.dirname(__FILE__)}/cache/rack/meta", "#{File.dirname(__FILE__)}/cache/rack/body" ].each do |dir|
  FileUtils.mkdir_p(dir) unless File.exists?(dir)
end

use Rack::Cache,
  :verbose     => true,
  :metastore   => "file:#{File.dirname(__FILE__)}/cache/rack/meta",
  :entitystore => "file:#{File.dirname(__FILE__)}/cache/rack/body"

require File.expand_path(File.join(File.dirname(__FILE__), 'app'))

set :run, false
run Sinatra::Application

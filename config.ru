require 'bundler/setup'
Bundler.require(:default, :development)

require 'sinatra'
require 'fileutils'

$ROOT = File.expand_path(File.join(File.dirname(__FILE__)))

require File.join($ROOT, 'app')

use Rack::ConditionalGet
use Rack::ETag
use Stethoscope

set :run, false
run Sinatra::Application

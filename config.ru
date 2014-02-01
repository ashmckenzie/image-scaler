require 'sinatra'
require 'fileutils'

require File.expand_path(File.join('..', 'config', 'initialise'), __FILE__)

require './app/web_app'

run ImageScaler::WebApp

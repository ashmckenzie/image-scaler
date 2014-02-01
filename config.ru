require 'sinatra'
require 'fileutils'

require File.expand_path(File.join('..', 'config', 'initialise'), __FILE__)

require 'image_scaler/web_app'

run ImageScaler::WebApp

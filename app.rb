#!/usr/bin/env ruby

require 'sinatra'
require 'open-uri'
require 'dragonfly'

app = Dragonfly[:images].configure_with(:imagemagick)

get '/images/:size' do |size|
  app.fetch_file(open(params['file'])).thumb(size).to_response(env)
end

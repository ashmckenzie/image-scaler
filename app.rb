#!/usr/bin/env ruby

require 'sinatra'
require 'open-uri'
require 'dragonfly'

app = Dragonfly[:images].configure_with(:imagemagick)

# http://localhost:4567/images/400x400?file=http://i.imgur.com/D3PRv.jpg
#
get '/images/:size' do |size|
  app.fetch_file(open(params['file'])).thumb(size).to_response(env)
end
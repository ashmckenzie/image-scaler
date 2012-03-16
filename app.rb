require 'open-uri'
require 'cgi'
require 'pathname'
require 'dragonfly'

app = Dragonfly[:images].configure_with(:imagemagick)

get '/' do
  erb :index
end

post '/' do
  redirect "/images/#{params['height']}x#{params['width']}/#{CGI.escape(params['url'])}"
end

get '/images/:size/*' do |size, image|
  image.gsub!(/^http:\/{1,}/, 'http://')
  app.fetch_file(open(image)).thumb(size).to_response(env)
end
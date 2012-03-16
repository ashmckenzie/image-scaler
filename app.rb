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

get '/images/:size/:image' do |size, image|
  content = app.fetch_file(open(image)).thumb(size).to_response(env)
  cache_it(request.env['REQUEST_PATH'][1..-1], content)
  content
end

private

def cache_it location, content
  file = Pathname.new($ROOT + "/public/" + location)
  FileUtils.mkdir_p(file.dirname)
  File.open(file, 'w') do |f|
    f.write(content)
  end
end
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
  content = app.fetch_file(open(image)).thumb(size).to_response(env)
  cache_it(request.env['REQUEST_URI'][1..-1], content[2])
  content
end

private

def cache_it location, content
  file = Pathname.new($ROOT + "/public/" + location)
  FileUtils.mkdir_p(file.dirname)
  File.open(file, 'w') do |f|
    f.write(content.data)
  end
end
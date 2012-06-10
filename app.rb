require 'open-uri'
require 'cgi'
require 'pathname'
require 'dragonfly'

Dir[File.join('config', 'initialisers', '*.rb')].each { |f| require "./#{f}" }

app = Dragonfly[:images].configure_with(:imagemagick)

before do
  halt 401, 'Access denied' unless $APP_CONFIG.api_keys.include? params[:api_key]
  @api_key = params[:api_key]
end

get '/' do
  erb :index
end

post '/' do
  redirect "/images/#{params['height']}x#{params['width']}/#{CGI.escape(params['url'])}?api_key=#{params['api_key']}"
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
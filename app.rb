require 'open-uri'
require 'cgi'
require 'dragonfly'

Dir[File.join('config', 'initialisers', '*.rb')].each { |f| require "./#{f}" }

app = Dragonfly[:images].configure_with(:imagemagick)

if production?
  before do
    halt 401, 'Access denied' unless $APP_CONFIG.api_keys.include? params[:api_key]
    @api_key = params[:api_key]
  end
end

get '/' do
  erb :index
end

post '/' do
  redirect "/images/#{params['height']}x#{params['width']}/#{CGI.escape(params['url'])}?api_key=#{params['api_key']}"
end

get '/images/:size/*' do |width_and_height, image_url|
  ImageScaler::Image.new(image_url, width_and_height).render!(app, env)
end

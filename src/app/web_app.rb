require 'sinatra/base'
require 'sinatra/reloader'
require 'cgi'

module ImageScaler
  class WebApp < Sinatra::Base

    configure :development do
      require 'pry-byebug'
      register Sinatra::Reloader
      LIBRARIES.each { |f| also_reload(f) }
    end

    configure :production do
      use ::Rack::CommonLogger

      before do
        halt 401, 'Access denied' unless api_key_valid?(params[:api_key])
        @api_key = params[:api_key]
      end
    end

    use Rack::ConditionalGet
    use Rack::ETag
    use Stethoscope

    set :views, File.join(ROOT_PATH, 'views')

    get '/' do
      erb :index
    end

    post '/' do
      redirect '/images/%sx%s/%s?api_key=%s' % [ params['height'], params['width'], CGI.escape(params['url']), params['api_key'] ]
    end

    get '/images/:size/*' do |desired_dimensions, url|
      resized_image = Image::Resize.new(env).resize!(url, desired_dimensions)
      cache_file = cache_file_for(env)
      Image::Cache.new(resized_image, cache_file).cache! unless cache_file_exists?(cache_file)
      resized_image.to_response(env)
    end

    private

      def valid_api_keys
        @valid_api_keys ||= ENV.fetch('IMAGE_SCALER_API_KEYS', '').split(',')
      end

      def api_key_valid?(api_key)
        valid_api_keys.include?(api_key)
      end

      def cache_file_for(env)
        # from this: /images/100x100/http%3A%2F%2Festrip.org%2Fcontent%2Fusers%2Ftinypliny%2F0409%2FGrannySmith0404.jpg?api_key=
        # to this:   100x100/http%3A%2F%2Festrip.org%2Fcontent%2Fusers%2Ftinypliny%2F0409%2FGrannySmith0404.jpg
        env['REQUEST_URI'].gsub(/\?.*$/, '').gsub(%r{^/images/}, '')
      end

      def cache_file_exists?(file)
        File.exist?(File.join(cache_path, file))
      end

      def cache_path
        ENV['APP_CACHE_PATH']
      end
  end
end

require 'pathname'

module ImageScaler
  class Image

    extend Forwardable

    def initialize raw_url, width_and_height
      @url = raw_url.gsub!(/^http:\/{1,}/, 'http://')
      @file = open(url)
      @new_dimensions = Dimensions.new(width_and_height)
    end

    def render! app, env
      dragon_fly_image = DragonFlyImage.new(resize!(app, env))
      cache!(cache_file(env), dragon_fly_image.data)
      dragon_fly_image.response
    end

    def_delegators :dimensions, :width, :height

    private

    attr_reader :app, :env, :url, :file, :new_dimensions

    def dimensions
      @dimensions ||= ImageDimensions.new(file)
    end

    def cache_file env
      path = env['REQUEST_URI'][1..-1].gsub(/\?.*$/, '')
      @cache_file ||= Pathname.new($ROOT + "/public/" + path)
    end

    def resize! app, env
      response = app.fetch_file(file)
      response = response.send(:thumb, new_dimensions.to_s) if resize?
      response.to_response(env)
    end

    def ensure_location_exists! location
      FileUtils.mkdir_p(location.dirname)
    end

    def resize?
      width > new_dimensions.width && height > new_dimensions.height
    end

    def cache! location, content
      ensure_location_exists!(location)
      File.open(location, 'w') do |f|
        f.write(content)
      end
    end
  end
end

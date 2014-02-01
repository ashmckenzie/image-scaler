# encoding: UTF-8

require 'dragonfly'

module ImageScaler
  module Image
    class Resize

      Dragonfly.app.configure do
        datastore :file,
          root_path:  'public/images',
          store_meta: false

        plugin :imagemagick
      end

      def initialize rack_env
        @rack_env = rack_env
      end

      def resize! url, desired_dimensions
        desired_dimensions = Dimensions.new(desired_dimensions)
        remote_image = dragonfly.fetch_url(sanitise_url(url))

        if resize?(remote_image, desired_dimensions)
          remote_image.thumb(desired_dimensions.to_s)
        else
          remote_image
        end
      end

      private

        attr_reader :rack_env

        def dragonfly
          @dragonfly ||= Dragonfly.app
        end

        def sanitise_url url
          url.gsub!(/^http:\/{1,}/, 'http://')  # FIXME: why ?
        end

        def resize? remote_image, desired_dimensions
          remote_image.width > desired_dimensions.width && remote_image.height > desired_dimensions.height
        end
    end
  end
end

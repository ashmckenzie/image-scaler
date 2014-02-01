# encoding: UTF-8

require 'fileutils'

module ImageScaler
  module Image
    class Cache

      def initialize image, cache_file
        @image = image
        @cache_file = cache_file
      end

      def cache!
        image.store(path: cache_file)
      end

      private

        attr_reader :image, :cache_file

    end
  end
end

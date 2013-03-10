require 'dimensions'

module ImageScaler
  class ImageDimensions

    attr_reader :width, :height

    def initialize image
      @width, @height = ::Dimensions.dimensions(image)
    end

    def to_s
      "#{width}x#{height}"
    end
  end
end

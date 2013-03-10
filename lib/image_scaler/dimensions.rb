module ImageScaler
  class Dimensions

    attr_reader :width, :height

    def initialize width_and_height
      @width, @height = width_and_height.split(/x/).map(&:to_i)
    end

    def to_s
      "#{width}x#{height}"
    end
  end
end

module ImageScaler
  class DragonFlyImage

    attr_reader :response

    def initialize response
      @response = response
    end

    def data
      response[2].data
    end
  end
end

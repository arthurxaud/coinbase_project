module GdaxAPI
  class Order
    attr_reader :price, :size

    def initialize(price, size)
      @price = price
      @size = size
    end

    def total
      price * size
    end
  end
end

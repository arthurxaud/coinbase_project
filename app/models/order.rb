class Order
  attr_reader :price, :size

  def initialize(price, size)
    @price = price
    @size = size
  end

  def invert
    self.class.new(1 / price, size * price)
  end

  def total
    price * size
  end
end

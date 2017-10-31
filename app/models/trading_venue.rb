class TradingVenue
  cattr_accessor :client do
    GdaxAPI::Client.new
  end

  def self.book_for(currency_pair)
    orders = client.order_book(currency_pair.to_s)
    return OrderBook.new(orders) if orders
    inverted_book_for(currency_pair)
  end

  def self.inverted_book_for(currency_pair)
    orders = client.order_book(currency_pair.invert.to_s)
    return OrderBook.new(orders).invert if orders
    raise Error::ObjectNotFound, 'Currency-pair not found'
  end
end

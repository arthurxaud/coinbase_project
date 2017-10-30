module GdaxAPI
  class InvertedOrderBook
    attr_reader :asks, :bids, :sequence

    def initialize(params)
      @asks = create_orders(params[:bids])
      @bids = create_orders(params[:asks])
      @sequence = params[:sequence]
    end

    def type
      'inverted'
    end

    private

    def create_orders(params)
      params.map do |aggregated_order|
        price = BigDecimal.new(aggregated_order[0])
        size = BigDecimal.new(aggregated_order[1])
        inverted_price = 1 / price
        inverted_size = size * price
        Order.new(inverted_price, inverted_size)
      end
    end
  end
end

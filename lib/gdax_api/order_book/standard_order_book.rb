module GdaxAPI
  class StandardOrderBook
    attr_reader :asks, :bids, :sequence

    def initialize(params)
      @asks = create_orders(params[:asks])
      @bids = create_orders(params[:bids])
      @sequence = params[:sequence]
    end

    def type
      'standard'
    end

    private

    def create_orders(params)
      params.map do |aggregated_order|
        price = BigDecimal.new(aggregated_order[0])
        size = BigDecimal.new(aggregated_order[1])
        Order.new(price, size)
      end
    end
  end
end

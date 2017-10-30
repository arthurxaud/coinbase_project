module GdaxAPI
  module API
    class << self
      def order_book(base_currency, quote_currency)
        params = OrderBookRequest.perform(base_currency, quote_currency)
        return StandardOrderBook.new(params) if params
        inverse_order_book(quote_currency, base_currency)
      end

      private

      def inverse_order_book(quote_currency, base_currency)
        params = OrderBookRequest.perform(quote_currency, base_currency)
        return InvertedOrderBook.new(params) if params
        raise ActiveRecord::RecordNotFound, 'Invalid currency-pair'
      end
    end
  end
end

module GdaxAPI
  module OrderBookRequest
    extend GdaxAPI::Request

    class << self
      def perform(base_currency, quote_currency, level = 2)
        product_id = product_id(base_currency, quote_currency)
        path = "/products/#{product_id}/book"
        get(path, level: level)
      end

      private

      def product_id(base_currency, quote_currency)
        "#{base_currency}-#{quote_currency}"
      end
    end
  end
end

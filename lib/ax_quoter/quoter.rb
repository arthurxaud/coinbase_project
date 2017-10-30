module AxQuoter
  class Quoter
    attr_reader :action, :base_currency, :quote_currency, :amount

    def initialize(params)
      @action = params[:action]
      @base_currency = params[:base_currency]
      @quote_currency = params[:quote_currency]
      @amount = BigDecimal.new(params[:amount])
    end

    def quote
      order_book = order_book(base_currency, quote_currency)
      total = total_price(order_book)
      response(total)
    end

    private

    def order_book(base_currency, quote_currency)
      GdaxAPI::API.order_book(base_currency, quote_currency)
    end

    def total_price(order_book)
      Calculator.new(order_book, action, amount).total_price
    end

    def response(total)
      { total: Helpers::Precision.currency(total, quote_currency),
        price: Helpers::Precision.currency((total / amount), quote_currency),
        currency: quote_currency }
    end
  end
end

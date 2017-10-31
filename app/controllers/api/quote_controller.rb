module API
  class QuoteController < ApplicationController
    skip_before_action :verify_authenticity_token, if: :json_request?
    # include Error::Handler

    def quote
      trader = Trader.new(quote_params)
      quote = trader.quote
      render json: quote, status: 200
    end

    def quote_params
      permitted_params = %w[action base_currency quote_currency amount]
      params.require(:quote).permit(*permitted_params)
    end
  end
end

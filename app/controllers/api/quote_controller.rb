module API
  class QuoteController < ApplicationController
    skip_before_action :verify_authenticity_token, if: :json_request?

    include AxQuoter::ErrorHandler

    def quote
      return unless valid_params?(quote_params) == true
      quoter = AxQuoter::Quoter.new(quote_params)
      quote = quoter.quote
      render json: quote, status: 200
    end

    def quote_params
      permitted_params = %w[action base_currency quote_currency amount]
      permitted_params.each { |param| params.require(:quote).require(param) }
      params.require(:quote).permit(*permitted_params)
    end

    protected

    def valid_params?(params)
      errors = []
      errors << 'invalid action' unless %w[buy sell].include?(params['action'])
      errors << 'invalid amount' unless params['amount'].match(/^\d+\.?\d*$/)

      return true if errors.empty?

      json = { error: 'invalid_params', status: 400, message: errors }.to_json
      render json: json, status: 400
    end

    def json_request?
      request.format.json?
    end
  end
end

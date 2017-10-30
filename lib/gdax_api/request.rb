module GdaxAPI
  module Request
    URL = 'https://api.gdax.com'.freeze
    SUCCESS_CODE = '200'.freeze

    def get(path, params)
      uri = build_uri(path, params)
      response = get_response(uri)
      parse(response)
    end

    private

    def build_uri(path, params)
      uri = URI(URL + path)
      uri.query = URI.encode_www_form(params)
      uri
    end

    def get_response(uri)
      Net::HTTP.get_response(uri)
    end

    def parse(response)
      return unless response.code == SUCCESS_CODE
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end

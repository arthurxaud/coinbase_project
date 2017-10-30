require 'spec_helper'
require 'gdax_api'
require 'webmock/rspec'

RSpec.describe GdaxAPI::OrderBookRequest do
  let(:dummy_class) { Class.new { extend GdaxAPI::Request } }

  before { stub_request(:get, /api.gdax.com/).to_return(status: 400) }

  before do
    stub_request(:get, 'https://api.gdax.com/products/FOO-BAR/book')
      .with(query: { level: 2 })
      .to_return(status: 200, body: "{\"success\":true}")
  end

  describe '.perform' do
    it 'requests order book based on currency-pair' do
      uri = URI('https://api.gdax.com/products/FOO-BAR/book?level=2')
      expect(Net::HTTP)
        .to receive(:get_response).with(uri).and_call_original
      GdaxAPI::OrderBookRequest.perform('FOO', 'BAR')
    end
  end
end

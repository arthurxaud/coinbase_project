require 'spec_helper'
require 'gdax_api'
require 'webmock/rspec'

RSpec.describe GdaxAPI::API do
  describe '.order_book' do
    before do
      stub_request(:get, /api.gdax.com/).to_return(status: 400)
      stub_request(:get, /api.gdax.com.*BTC-USD/)
        .to_return(response_for(:order_book))
    end

    context 'when currency-pair is valid' do
      it 'returns order book from api' do
        order_book = GdaxAPI::API.order_book('BTC', 'USD')
        expect(order_book.is_a?(GdaxAPI::StandardOrderBook)).to eq(true)
      end
    end

    context 'when currency-pair is inverted' do
      it 'returns inverted order book from api' do
        order_book = GdaxAPI::API.order_book('USD', 'BTC')
        expect(order_book.is_a?(GdaxAPI::InvertedOrderBook)).to eq(true)
      end
    end

    context 'when currency-pair is invalid' do
      it 'raises not found error' do
        expect do
          GdaxAPI::API.order_book('FOO', 'BAR')
                      .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  def response_for(resource_name)
    {
      status: 200,
      'Content-Type' => 'application/json',
      body: File.binread(fixture_file(resource_name))
    }
  end

  def fixture_file(resource_name)
    File.dirname(__FILE__) + "/fixtures/#{resource_name}.json"
  end
end

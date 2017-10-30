require 'spec_helper'
require 'gdax_api'

RSpec.describe GdaxAPI::InvertedOrderBook do
  let(:params) { { bids: [[1, 2], [3, 4]], asks: [[5, 6]] } }
  let(:order_book) { GdaxAPI::InvertedOrderBook.new(params) }

  describe '#bids' do
    it 'returns an array with inverted bids (asks) orders' do
      bids = order_book.bids
      asks = params[:asks]
      expect(bids.count).to eq(asks.count)
      expect(bids.sample.is_a?(GdaxAPI::Order)).to eq(true)
    end

    it 'returns bids (asks) orders with inverted price and size' do
      order_book.bids.each_with_index do |o, i|
        price = BigDecimal.new(params[:asks][i][0])
        size = BigDecimal.new(params[:asks][i][1])
        expect(o.price).to eq(1 / price)
        expect(o.size).to eq(size * price)
      end
    end
  end

  describe '#asks' do
    it 'returns an array with inverted asks (bids) orders' do
      asks = order_book.asks
      bids = params[:bids]
      expect(asks.count).to eq(bids.count)
      expect(asks.sample.is_a?(GdaxAPI::Order)).to eq(true)
    end

    it 'returns asks (bids) orders with inverted price and size' do
      order_book.asks.each_with_index do |o, i|
        price = BigDecimal.new(params[:bids][i][0])
        size = BigDecimal.new(params[:bids][i][1])
        expect(o.price).to eq(1 / price)
        expect(o.size).to eq(size * price)
      end
    end
  end

  describe '#type' do
    it 'returns inverted' do
      expect(order_book.type).to eq('inverted')
    end
  end
end

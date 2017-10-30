require 'spec_helper'
require 'gdax_api'

RSpec.describe GdaxAPI::StandardOrderBook do
  let(:params) { { bids: [[1, 2], [3, 4]], asks: [[5, 6]] } }
  let(:order_book) { GdaxAPI::StandardOrderBook.new(params) }

  describe '#bids' do
    it 'returns an array with bids orders' do
      bids = order_book.bids
      expect(bids.count).to eq(2)
      expect(bids.sample.is_a?(GdaxAPI::Order)).to eq(true)
    end

    it 'returns bids orders with standard price and size' do
      order_book.bids.each_with_index do |o, i|
        price = BigDecimal.new(params[:bids][i][0])
        size = BigDecimal.new(params[:bids][i][1])
        expect(o.price).to eq(price)
        expect(o.size).to eq(size)
      end
    end
  end

  describe '#asks' do
    it 'returns an array with asks orders' do
      asks = order_book.asks
      expect(asks.count).to eq(1)
      expect(asks.sample.is_a?(GdaxAPI::Order)).to eq(true)
    end

    it 'returns asks orders with standard price and size' do
      order_book.asks.each_with_index do |o, i|
        price = BigDecimal.new(params[:asks][i][0])
        size = BigDecimal.new(params[:asks][i][1])
        expect(o.price).to eq(price)
        expect(o.size).to eq(size)
      end
    end
  end

  describe '#type' do
    it 'returns standard' do
      expect(order_book.type).to eq('standard')
    end
  end
end

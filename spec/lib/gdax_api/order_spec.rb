require 'spec_helper'
require 'gdax_api'

RSpec.describe GdaxAPI::Order do
  let(:price) { BigDecimal.new('10.0') }
  let(:size) { BigDecimal.new('5.0') }
  let(:order) { GdaxAPI::Order.new(price, size) }

  describe '#price' do
    it 'returns orders price' do
      expect(order.price).to eq(BigDecimal.new('10.0'))
    end
  end

  describe '#size' do
    it 'returns orders size' do
      expect(order.size).to eq(BigDecimal.new('5.0'))
    end
  end

  describe '#total' do
    it 'returns orders price multiplied by size' do
      expect(order.total).to eq(BigDecimal.new('50.0'))
    end
  end
end

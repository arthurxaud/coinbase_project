require 'spec_helper'
require 'ax_quoter'

RSpec.describe AxQuoter::Calculator do
  OrderBook = Struct.new(:asks, :bids)
  Order = Struct.new(:price, :size)

  describe '#total' do
    let(:book) { stubbed_book }

    context 'when action is buy' do
      let(:calculator) { AxQuoter::Calculator.new(book, 'buy', 15) }

      it 'gets asks from order book' do
        expect_any_instance_of(OrderBook)
          .to receive(:send).with(:asks).and_call_original
        calculator.total_price
      end

      it 'returns sum of weighted prices from asks orders for desired amount' do
        total_price = calculator.total_price
        expect(total_price).to eq(10 * 5 + 11 * 8 + 12 * 2)
      end
    end

    context 'when action is sell' do
      let(:calculator) { AxQuoter::Calculator.new(book, 'sell', 15) }

      it 'gets bids from order book' do
        expect_any_instance_of(OrderBook)
          .to receive(:send).with(:bids).and_call_original
        calculator.total_price
      end

      it 'returns sum of weighted prices from bids orders for desired amount' do
        total_price = calculator.total_price
        expect(total_price).to eq(8 * 10 + 7 * 5)
      end
    end

    def stubbed_book
      asks = [[10, 5], [11, 8], [12, 19]].map { |order| Order.new(*order) }
      bids = [[8, 10], [7, 5], [6, 14]].map { |order| Order.new(*order) }
      OrderBook.new(asks, bids)
    end
  end
end

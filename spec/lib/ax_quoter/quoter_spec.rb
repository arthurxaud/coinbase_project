require 'spec_helper'
require 'ax_quoter'

RSpec.describe AxQuoter::Quoter do
  OrderBook = Struct.new(:asks, :bids)
  Order = Struct.new(:price, :size)

  describe '#quote' do
    let(:book) { stubbed_book }
    let(:params) do
      { base_currency: 'FOO', quote_currency: 'BAR', amount: '12' }
    end

    before { allow(GdaxAPI::API).to receive(:order_book).and_return(book) }

    context 'when action is buy' do
      let(:buy_params) { params.merge(action: 'buy') }
      let(:quoter) { AxQuoter::Quoter.new(buy_params) }

      it 'returns lowest price to buy this amount in the quote currency and unit price' do
        response = quoter.quote
        expected_total = BigDecimal.new((10 * 5) + (11 * 7))
        expect(response[:total]).to eq('%0.8f' % expected_total)
        expect(response[:price]).to eq('%0.8f' % (expected_total / 12))
        expect(response[:currency]).to eq('BAR')
      end
    end

    context 'when action is sell' do
      let(:sell_params) { params.merge(action: 'sell') }
      let(:quoter) { AxQuoter::Quoter.new(sell_params) }

      it 'returns highest price to sell this amount in the quote currency and unit price' do
        response = quoter.quote
        expected_total = BigDecimal.new((8 * 10) + (7 * 2))
        expect(response[:total]).to eq('%0.8f' % expected_total)
        expect(response[:price]).to eq('%0.8f' % (expected_total / 12))
        expect(response[:currency]).to eq('BAR')
      end
    end

    context 'when amount is exceeded' do
      it 'raises amount exceeded error' do
        params.merge!(action: 'buy', amount: '1000000.0')
        quoter = AxQuoter::Quoter.new(params)
        expect { quoter.quote }.to raise_error(AxQuoter::AmountExceededError)
      end
    end

    def stubbed_book
      asks = [[10, 5], [11, 8], [12, 19]].map { |order| Order.new(*order) }
      bids = [[8, 10], [7, 5], [6, 14]].map { |order| Order.new(*order) }
      OrderBook.new(asks, bids)
    end
  end
end

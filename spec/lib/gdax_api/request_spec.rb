require 'spec_helper'
require 'gdax_api'
require 'webmock/rspec'

RSpec.describe GdaxAPI::Request do
  let(:dummy_class) { Class.new { extend GdaxAPI::Request } }

  before { stub_request(:get, /api.gdax.com/).to_return(status: 400) }

  describe '.get' do
    context 'when request is valid' do
      let!(:stub) do
        stub_request(:get, 'https://api.gdax.com/foo')
          .with(query: { foo: :bar })
          .to_return(status: 200, body: "{\"success\":true}")
      end

      it 'performs to path at gdax api with query params' do
        uri = URI('https://api.gdax.com/foo?foo=bar')
        expect(Net::HTTP)
          .to receive(:get_response).with(uri).and_call_original
        dummy_class.get('/foo', foo: :bar)
      end

      it 'returns a parsed json' do
        response = dummy_class.get('/foo', foo: :bar)
        expect(response[:success]).to eq(true)
      end
    end

    context 'when request is invalid' do
      it 'returns nothing' do
        response = dummy_class.get('/bar', {})
        expect(response).to eq(nil)
      end
    end
  end
end

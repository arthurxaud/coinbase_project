require 'rails_helper'

RSpec.describe API::QuoteController, type: :controller do
  let(:valid_attributes) do
    { 'base_currency' => 'BTC', 'quote_currency' => 'USD',
      'amount' => '2.0', 'action' => 'buy' }
  end

  let(:valid_response) do
    { total: '10000.00', price: '5000.00', quote_currency: 'USD' }
  end

  before do
    allow_any_instance_of(AxQuoter::Quoter).to receive(:quote)
      .and_return(valid_response)
  end

  describe 'POST #quote' do
    context 'when request is json' do
      context 'with valid params' do
        before { post :quote, format: :json, quote: valid_attributes }

        it 'returns a success response' do
          expect(response.status).to eq(200)
        end

        it 'returns quote in json' do
          json = JSON.parse(response.body)

          expect(json['total']).to eq('10000.00')
          expect(json['price']).to eq('5000.00')
          expect(json['quote_currency']).to eq('USD')
        end
      end

      context 'with missing params' do
        it 'returns parameter missing error with status 400' do
          valid_attributes.delete('base_currency')
          post :quote, format: :json, quote: valid_attributes
          expect(response.status).to eq(400)

          message_format = 'param is missing or the value is empty: %s'
          json = JSON.parse(response.body)

          expect(json['error']).to eq('parameter_missing')
          expect(json['status']).to eq(400)
          expect(json['message']).to eq(message_format % 'base_currency')
        end
      end

      context 'with invalid action' do
        it 'returns invalid params error with status 400' do
          valid_attributes['action'] = 'foo'
          post :quote, format: :json, quote: valid_attributes
          expect(response.status).to eq(400)

          json = JSON.parse(response.body)
          expect(json['error']).to eq('invalid_params')
          expect(json['status']).to eq(400)
          expect(json['message']).to eq(['invalid action'])
        end
      end

      context 'with invalid amount' do
        it 'returns invalid params error with status 400' do
          valid_attributes['amount'] = '10f.12'
          post :quote, format: :json, quote: valid_attributes
          expect(response.status).to eq(400)

          json = JSON.parse(response.body)
          expect(json['error']).to eq('invalid_params')
          expect(json['status']).to eq(400)
          expect(json['message']).to eq(['invalid amount'])
        end
      end
    end

    context 'when request is not json' do
      it 'returns not acceptable error with status 406' do
        post :quote, {}

        expect(response.status).to eq(406)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('not acceptable')
        expect(json['status']).to eq(406)
        expect(json['message']).to eq('format not accepable')
      end
    end
  end
end

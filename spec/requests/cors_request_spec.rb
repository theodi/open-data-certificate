require_relative '../spec_helper'

describe 'CORS request' do

  context 'for the homepage' do
    it 'does not respond with Access-Control-Allow-Origin' do
      get '/en', nil, {'HTTP_ORIGIN' => 'http://example.com'}
      expect(response.headers['Access-Control-Allow-Origin']).to be_nil
    end
  end

  context 'CertificatesController#badge' do
    let(:dataset) { FactoryGirl.create(:dataset) }

    it 'returns Access-Control-Allow-Origin header' do
      get "/en/datasets/#{dataset.id}/certificate/badge.js", nil, {'HTTP_ORIGIN' => 'http://example.com'}
      expect(response.headers['Access-Control-Allow-Origin']).to eql('*')
    end

    context 'redirecting from old URL' do
      it 'returns Access-Control-Allow-Origin header' do
        get "/datasets/#{dataset.id}/certificate/badge.js", nil, {'HTTP_ORIGIN' => 'http://example.com'}
        expect(response.headers['Access-Control-Allow-Origin']).to eql('*')
        expect(response).to redirect_to("http://www.example.com/en/datasets/#{dataset.id}/certificate/badge.js")
      end
    end
  end

end

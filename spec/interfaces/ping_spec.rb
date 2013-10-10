require 'spec_helper'

describe Ping::API do
  # Test the Ping API by mounting it at /ping within a HAL
  # super-API. Instantiate the new super-API class to integrate with Rack Test.
  def app
    API.new
  end

  context 'with application/hal+json' do
    # All positive expectations succeed only with the application/hal+json
    # request content type. The API is HAL! See
    # http://stateless.co/hal_specification.html for details.
    before(:each) do
      header 'Accept', 'application/hal+json'
    end

    after(:each) do
      expect(last_response).to be_ok
    end

    it 'responds with pong by default' do
      get '/ping'
      expect(last_response.body).to eq({ ping: :pong }.to_json)
    end

    it 'responds with arbitrary text' do
      get '/ping', { pong: 'xyz' }
      expect(last_response.body).to eq({ ping: 'xyz' }.to_json)
    end
  end

  context 'without application/hal+json' do
    after(:each) do
      expect(last_response).to_not be_ok
    end

    it 'responds with Not Acceptable' do
      get '/ping'
      expect(last_response.status).to eq(406)
    end

    it 'responds to JSON with Not Acceptable' do
      header 'Accept', 'application/json'
      get '/ping'
      expect(last_response.status).to eq(406)
    end
  end
end

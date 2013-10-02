require 'spec_helper'

describe Ping::API do
  include Rack::Test::Methods

  # Test the Ping API by mounting it at /ping within a HAL
  # super-API. Instantiate the new super-API class to integrate with Rack Test.
  def app
    Class.new(Grape::API) do
      content_type :hal, 'application/hal+json'
      formatter :hal, Grape::Formatter::SerializableHash

      mount Ping::API => '/ping'
    end.new
  end

  describe 'positive expectations' do
    # All positive expectations succeed only with the application/hal+json
    # request content type. The API is HAL! See
    # http://stateless.co/hal_specification.html for details.
    before(:each) do
      header 'Accept', 'application/hal+json'
    end

    after(:each) do
      last_response.should be_ok
    end

    it 'responds with pong by default' do
      get '/ping'
      last_response.body.should == { ping: :pong }.to_json
    end

    it 'responds with arbitrary text' do
      get '/ping', { pong: 'xyz' }
      last_response.body.should == { ping: 'xyz' }.to_json
    end
  end

  describe 'negative expectations' do
    after(:each) do
      last_response.should_not be_ok
    end

    it 'responds with Not Acceptable' do
      get '/ping'
      last_response.status.should == 406
    end

    it 'responds to JSON with Not Acceptable' do
      header 'Accept', 'application/json'
      get '/ping'
      last_response.status.should == 406
    end
  end
end

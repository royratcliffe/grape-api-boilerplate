require 'spec_helper'

describe API do
  # Integrate with Rack Test.
  def app
    API.new
  end

  before(:each) do
    header 'Accept', 'application/hal+json'
  end

  # GET requests on the API root path should answer with links: a link to self
  # matching the request URL; also links to other mounted services.
  describe '/' do
    it 'GET responds with _links' do
      get '/'
      last_response.should be_ok
      JSON.parse(last_response.body)['_links']['self']['href'].should == last_request.url
    end
  end
end

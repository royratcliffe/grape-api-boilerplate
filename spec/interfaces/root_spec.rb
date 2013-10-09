require 'spec_helper'
require 'json'

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
  describe 'GET /' do
    before do
      get '/'
    end

    subject { last_response }
    it { should be_ok }

    context 'JSON body' do
      subject { JSON.parse(last_response.body) }
      it { should_not be_nil }
      it { should include('_links') }

      context '_links' do
        subject { JSON.parse(last_response.body)['_links'] }
        it { should include('self') }
      end
    end
  end
end

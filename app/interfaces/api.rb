require 'grape'

class API < Grape::API
  # Accept application/hal+json content only.
  content_type :hal, 'application/hal+json'
  formatter :hal, Grape::Formatter::SerializableHash

  mount Ping::API => '/ping'
end

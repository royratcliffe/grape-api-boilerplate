require 'grape'

class Ping::API < Grape::API
  get do
    { ping: params[:pong] || 'pong' }
  end
end

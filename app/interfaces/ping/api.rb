require 'grape'

class Ping::API < Grape::API
  get do
    { ping: params[:ping] || 'pong' }
  end
end

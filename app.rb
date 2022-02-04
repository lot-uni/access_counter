require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models/count.rb'

set :sever, 'thin'
set :sockets, []

before do
  if Count.all.size == 0
    Count.create(number: 0)
  end
end

get '/' do
  erb :index
end

get '/websocket' do
  if request.websocket?
    require.websocket do |ws|
      ws.onopen do
        settings.sockets << ws
      end
      ws.onmessage do |msg|
        settings.sockets.each do |s|
          s.send(msg)
        end
      end
      ws.onclose do
        settings.sockets.delete(ws)
      end
    end
  end
end
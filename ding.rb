require 'rubygems'
require 'sinatra'
require 'lib/models/session'
require 'lib/models/timer'

get '/' do
  redirect "/#{Session.create.name}"
end

get '/:session' do
  @session = Session.first(:name => params[:session])
  redirect '/' unless @session
  haml :index
end


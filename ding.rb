require 'rubygems'
require 'sinatra'
require 'lib/models/session'

get '/' do
  redirect "/#{Session.create.name}"
end

get '/:session' do
  @session = Session.first(:name => params[:session])
  haml :index
end


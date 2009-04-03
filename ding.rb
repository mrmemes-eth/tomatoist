require 'rubygems'
require 'sinatra'

require 'environment'

get '/' do
  redirect "/#{Session.create.name}"
end

get '/:session' do
  redirect '/' unless @session = Session.first(:name => params[:session])
  haml :timers
end


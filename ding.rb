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

post '/:session/timers' do
  session = Session.first(:name => params[:session])
  session.timers.create(:timer => params[:timer])
  redirect "/#{session.name}"
end


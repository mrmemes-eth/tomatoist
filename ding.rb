require 'rubygems'
require 'sinatra'

require 'datamapper'
DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/db/ding.sqlite3")

$:.unshift(File.join(File.dirname(__FILE__),'lib','models'))

require 'session'
require 'timer'

get '/' do
  redirect "/#{Session.create.name}"
end

get '/:session' do
  @session = Session.first(:name => params[:session])
  redirect '/' unless @session
  haml :index
end


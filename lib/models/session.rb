require 'rubygems'
require 'sinatra'
require 'datamapper'

DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/db/ding.sqlite3")

class Session
  include DataMapper::Resource

  property :id, Serial
  property :name, String
end


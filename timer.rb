require 'rubygems'
require 'sinatra'
require 'datamapper'

DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/db/ding.sqlite3")

class Timer
  include DataMapper::Resource

  property :id, Serial
  property :user_id, Integer
  property :duration, Integer
end


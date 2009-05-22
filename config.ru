require 'rubygems'
require 'sinatra'

require 'ding'

Ding.set(:environment, (ENV['RACK_ENV'] || :development))
run Ding


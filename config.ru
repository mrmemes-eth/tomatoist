require 'rubygems'
require 'sinatra'

require 'lib/ding'
require 'rack/hoptoad'

use Rack::Hoptoad, '276a4c0a1715e7a29f976677bee2beff'

Ding.set(:environment, (ENV['RACK_ENV'] || :development))
run Ding


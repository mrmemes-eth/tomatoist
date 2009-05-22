require 'rubygems'
require 'sinatra'

require 'ding'
require 'rack_hoptoad'

use Rack::HoptoadNotifier, '276a4c0a1715e7a29f976677bee2beff'

Ding.set(:environment, (ENV['RACK_ENV'] || :development))
run Ding


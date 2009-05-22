require 'rubygems'
require 'sinatra'

require 'ding'

Ding.set(:environment, :production)
run Ding


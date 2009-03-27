require 'rubygems'
require 'sinatra'

Sinatra::Application.set( :environment => :production )

require 'ding'
run Sinatra::Application


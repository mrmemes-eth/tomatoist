require 'rubygems'

require 'spec'
require 'spec/interop/test'
require 'sinatra/test'

require 'dm-sweatshop'

require 'ding'

$:.push File.join(File.dirname(__FILE__), '..', 'lib', 'models')

require 'session'
require 'timer'

require File.expand_path(File.dirname(__FILE__) + '/fixtures')

DataMapper.setup(:default, 'sqlite3::memory:')
DataMapper.auto_migrate!

Sinatra::Application.set :environment, :test

Spec::Runner.configure do |config|
end


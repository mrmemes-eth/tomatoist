require 'rubygems'

require 'spec'
require 'spec/interop/test'
require 'sinatra/test'

require 'dm-sweatshop'

require 'ding'

require File.join(File.dirname(__FILE__),'fixtures')

DataMapper.setup(:default, 'sqlite3::memory:')
DataMapper.auto_migrate!

Sinatra::Application.set :environment, :test

Spec::Runner.configure do |config|
  before do
    [Session,Timer].each{|klass| klass.all.destroy!}
  end
end


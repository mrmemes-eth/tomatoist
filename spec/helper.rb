require 'rubygems'

require 'spec'
require 'spec/interop/test'
require 'rack/test'

require 'dm-sweatshop'

require 'ding'

require File.join(File.dirname(__FILE__),'fixtures')

DataMapper.setup(:default, 'sqlite3::memory:')
DataMapper.auto_migrate!

Ding.set(:environment, :test)

Spec::Runner.configure do |config|
  include Rack::Test::Methods

  config.before do
    [Session,Timer].each{|klass| klass.all.destroy! }
  end

  def app
    Ding
  end

  def body
    last_response.body
  end

  def status
    ResponseStatus.new last_response.status
  end

  def redirected_to
    last_response.headers['Location']
  end
end

class ResponseStatus
  attr_reader :code

  def initialize(code)
    @code = code
  end

  def success?
    code == 200
  end

  def redirect?
    (300..399).include? code
  end
end

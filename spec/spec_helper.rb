PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

require 'fabrication'
require File.expand_path(File.dirname(__FILE__) + "/fabrications")

RSpec.configure do |conf|
  conf.mock_with :rspec
  conf.after(:each) do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  Tomatoist.tap do |app|
  end
end

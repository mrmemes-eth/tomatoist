PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)

require File.expand_path(File.dirname(__FILE__) + "/../../config/boot")

require 'capybara/cucumber'

Capybara.app = Tomatoist.tap { |app| }

class TomatoistWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

Before do
  Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
end

World do
  TomatoistWorld.new
end


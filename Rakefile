require 'rspec/core/rake_task'
require 'cucumber/rake/task'

desc "Run specs"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = %w(-fs --color)
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty --tags ~@wip"
end

task default: [:spec, :features]

begin
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'
rescue LoadError
  puts "RSpec and/or Cucumber are unavailable"
end

desc "Run specs"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = %w(-fs --color)
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty --tags ~@wip"
end

task default: [:spec, :features]

desc "Package for webstore"
task :pkg do
  require 'zippy'
  Zippy.create('tomatoist.zip') do |zip|
    Dir.glob('webstore/**/*').each do |file|
      zip[file] = File.open(file) unless File.directory?(file)
    end
  end
end

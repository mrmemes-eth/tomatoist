require 'rubygems'
require 'spec/rake/spectask'

require 'environment'

task :default => :spec

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end


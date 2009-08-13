require 'rubygems'
require 'spec/rake/spectask'

require 'config/environment'

task :default => :spec

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end

namespace :db do
  desc 'Auto-migrate the database (destroys data)'
  task :migrate do
    DataMapper.auto_migrate!
  end

  desc 'Auto-upgrade the database (preserves data)'
  task :upgrade do
    DataMapper.auto_upgrade!
  end
end



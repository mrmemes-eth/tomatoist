require 'datamapper'
require 'erb'

config_dir = File.expand_path(File.dirname(__FILE__))
database_file = File.read(File.join(config_dir,'database.yml'))
database_hash = YAML.load(ERB.new(database_file).result)

Dir.glob(File.join(config_dir,'..','lib','helpers','*.rb')){|f| require f }
Dir.glob(File.join(config_dir,'..','lib','**','*.rb')){|f| require f }

DataMapper.setup(:default, ENV['DATABASE_URL'] || database_hash[Ding.environment])


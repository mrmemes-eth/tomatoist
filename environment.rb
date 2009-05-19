require 'datamapper'
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:db/ding.sqlite3")

Dir.glob(File.join(File.dirname(__FILE__),'lib','**','*.rb')){ |f| require f }


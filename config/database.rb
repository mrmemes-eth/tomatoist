# Connection.new takes host, port
host = 'localhost'
port = Mongo::Connection::DEFAULT_PORT

database_name = case Padrino.env
  when :development then 'foobles_development'
  when :production  then 'foobles_production'
  when :test        then 'foobles_test'
end

Mongoid.database = Mongo::Connection.new(host, port).db(database_name)

# You can also configure Mongoid this way
# Mongoid.configure do |config|
#   name = @settings["database"]
#   host = @settings["host"]
#   config.master = Mongo::Connection.new.db(name)
#   config.slaves = [
#     Mongo::Connection.new(host, @settings["slave_one"]["port"], :slave_ok => true).db(name),
#     Mongo::Connection.new(host, @settings["slave_two"]["port"], :slave_ok => true).db(name)
#   ]
# end
#
# More installation and setup notes are on http://mongoid.org/docs/


if ENV.has_key?('MONGOHQ_URL')
  uri = URI.parse(ENV['MONGOHQ_URL'])
  Mongoid.database = Mongo::Connection.from_uri(uri.to_s).db(uri.path[/[^\/](.*)/])
else
  port = Mongo::Connection::DEFAULT_PORT

  database_name = case Padrino.env
    when :development then 'tomatoist_development'
    when :test        then 'tomatoist_test'
  end

  Mongoid.database = Mongo::Connection.new('localhost', port).db(database_name)
end

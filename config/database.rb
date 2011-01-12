DataMapper.logger = logger
DataMapper.setup(:default, "postgres://postgres@localhost/tomatoist_#{Padrino.env}")

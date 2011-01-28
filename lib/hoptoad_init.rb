module HoptoadInitializer
  def self.registered(app)
    app.use Rack::Hoptoad, 'd765d559676cf5ef2526db022520e85ff298a91b'
  end
end

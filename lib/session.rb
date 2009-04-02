class Session
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :timers

  before :create, :generate_name

  def generate_name
    self.name = (Session.last ? Session.last.name : 'z').succ!
  end

  def self.last
    first(:order => [:id.desc])
  end
end


class Session
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :custom, String

  has n, :timers

  before :create, :generate_name

  def name
    custom || attribute_get(:name)
  end

  def generate_name
    self.name ||= (Session.last ? Session.last.name : 'z').succ!
  end

  def self.last
    first(:order => [:id.desc])
  end

  def self.retrieve(name)
    first(:conditions => [ 'name = ? or custom = ?' , name, name])
  end
end


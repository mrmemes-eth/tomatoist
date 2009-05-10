class Session
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :custom, String

  has n, :timers

  before :create, :generate_name

  def self.last
    first(:order => [:id.desc])
  end

  def self.retrieve(session)
    first(:conditions => [ 'name = ? or custom = ?' , session, session])
  end

  def display_name
    custom || name
  end

  def custom=(name)
    name.gsub!(/\s/,'_')
    name.gsub!(/[\W]/,'')
    attribute_set(:custom,name.downcase)
  end

  def last_timer
    timers.first(:order => [:created_at.desc])
  end

  protected

  def generate_name
    self.name = Session.next_name
  end

  def self.next_name
    (last ? last.name : 'z').succ!
  end

end


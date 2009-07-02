class Session
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :unique => true
  property :custom, String

  validates_is_unique :custom, :if => lambda{|s| s.custom }

  has n, :timers
  has n, :short_breaks
  has n, :long_breaks
  has n, :pomodoros

  before :create, :generate_name

  SHORTS_TIL_LONG = 3

  def self.last
    first(:order => [:id.desc])
  end

  def self.retrieve(session)
    first(:conditions => [ 'name = ? or custom = ?' , session, session])
  end

  def custom=(name)
    name.gsub!(/\s/,'_')
    name.gsub!(/[\W]/,'')
    attribute_set(:custom,name.downcase)
  end

  def display_name
    custom || name
  end

  def first_timer
    timers.first(:order => [:id.asc])
  end

  def last_timer
    timers.first(:order => [:id.desc])
  end

  def last_long
    timers.first(:type => LongBreak, :order => [:id.desc])
  end

  def iteration_start_timer
    last_long ? last_long : first_timer
  end

  def iteration_short_breaks_count
    short_breaks.count(:id.gte => iteration_start_timer.id)
  end

  def next_timer
    case
    when timers.empty?, [ShortBreak,LongBreak].include?(last_timer.class)
      Pomodoro
    when iteration_short_breaks_count < SHORTS_TIL_LONG  ; ShortBreak
    when iteration_short_breaks_count >= SHORTS_TIL_LONG ; LongBreak
    end
  end

  protected

  def generate_name
    self.name = Session.next_name
  end

  def self.next_name
    (last ? last.name : 'z').succ!
  end

end


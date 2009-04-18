require 'time'

class Timer
  include DataMapper::Resource

  property :id, Serial
  property :duration, Integer
  property :created_at, Time

  belongs_to :session

  validates_present :duration, :session_id

  before :create do
    self.created_at = Time.now.utc
  end

  MAPPINGS = { 'short' => {:duration => 5*60,  :long_name => 'Short Break'},
               'long'  => {:duration => 15*60, :long_name => 'Long Break'},
               'pomo'  => {:duration => 25*60, :long_name => 'Pomodoro'} }

  def self.recent
    all(:order => [:created_at.desc], :limit => 8)
  end

  def display_time
    if created_at.day == Time.now.utc.day
      created_at.strftime('%l:%M%p UTC').gsub(/^\s+/,'')
    else
      created_at.strftime('%m/%d at %l:%M%p UTC')
    end
  end

  def timer=(type)
    self.duration = MAPPINGS[type][:duration]
  end

  def name
    MAPPINGS.detect{|k,v| v[:duration] == duration}.last[:long_name]
  end

  def expiry
    created_at + duration
  end

  def to_js
    a = expiry.to_a[0..5].reverse
    a[1] = a[1] - 1
    a
  end

end


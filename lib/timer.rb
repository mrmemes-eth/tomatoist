require 'time'
require 'tzinfo'

class Timer
  include DataMapper::Resource

  property :id, Serial
  property :duration, Integer
  property :created_at, Time
  property :offset, String, :default => '0'

  belongs_to :session

  validates_present :duration, :session_id

  before :valid? do
    self.created_at = Time.now.utc if new_record?
  end

  MAPPINGS = {
    'short' => {:duration => 5*60,  :long_name => 'Short Break'},
    'long'  => {:duration => 15*60, :long_name => 'Long Break'},
    'pomo'  => {:duration => 25*60, :long_name => 'Pomodoro'}
  }

  def self.recent
    all(:order => [:created_at.desc], :limit => 8)
  end

  def created_at
    zone.local_to_utc(attribute_get(:created_at))
  end

  def zone
    TZInfo::Timezone.get(offset ? "Etc/GMT#{offset}" : 'UTC')
  end

  def display_time
    time = if created_today?
      created_at.strftime('%l:%M%p')
    else
      created_at.strftime('%l:%M%p on %m/%d')
    end
    time.gsub!(/^\s+/,'')
    offset == '0' ? time.gsub!(/(AM|PM)/,'\1 UTC') : time
  end

  def created_today?
    created_at.day == Time.now.utc.day
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


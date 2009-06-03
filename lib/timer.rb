require 'time'
require 'tzinfo'

class Timer
  include DataMapper::Resource

  property :id, Serial
  property :duration, Integer
  property :created_at, Time
  property :offset, String, :default => '0'
  property :type, Discriminator

  belongs_to :session

  validates_present :duration, :session_id

  before :valid? do
    self.created_at = Time.now.utc if new_record?
  end

  def self.recent
    all(:order => [:created_at.desc], :limit => 8)
  end

  def type=(type)
    descendant = get_descendant_class(type)
    attribute_set(:type,descendant)
    attribute_set(:duration,descendant::DURATION)
  end

  def created_at
    zone.local_to_utc(attribute_get(:created_at))
  end

  def created_today?
    created_at.day == Time.now.utc.day
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

  def expiry
    created_at + duration
  end

  def expired?
    expiry.to_i < now.to_i
  end

  def to_js
    a = expiry.to_a[0..5].reverse
    a[1] = a[1] - 1
    a
  end

  def zone
    TZInfo::Timezone.get(offset ? "Etc/GMT#{offset}" : 'UTC')
  end

  private

  def now
    zone.local_to_utc(Time.now.utc)
  end

  def get_descendant_class(type)
    return Timer unless %w(Pomodoro ShortBreak LongBreak).include?(type)
    Kernel.const_get(type)
  end

end


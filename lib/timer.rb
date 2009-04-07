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

  MAPPINGS = { 'short' => 5*60,
                'long' => 15*60,
                'pomo' => 25*60 }

  def timer=(type)
    self.duration = MAPPINGS[type]
  end

  def name
    MAPPINGS.detect{|k,v| v == duration}.first
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


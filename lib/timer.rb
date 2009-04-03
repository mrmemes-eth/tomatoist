class Timer
  include DataMapper::Resource

  property :id, Serial
  property :duration, Integer
  property :created_at, Time

  belongs_to :session

  validates_present :duration, :session_id

  def timer=(type)
    case type
    when 'short'; self.duration = 5*60
    when 'long' ; self.duration = 15*60
    when 'pomo' ; self.duration = 25*60
    end
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


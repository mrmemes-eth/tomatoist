class LongBreak < Timer
  DURATION = 15*60

  property :duration, Integer, :default => DURATION

  def self.label
    'Long Break'
  end

  def self.nick
    'long'
  end

  def created_at
    zone.local_to_utc(attribute_get(:created_at))
  end
end

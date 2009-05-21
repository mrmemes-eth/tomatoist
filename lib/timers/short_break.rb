class ShortBreak < Timer
  DURATION = 5*60

  property :duration, Integer, :default => DURATION

  def self.label
    'Short Break'
  end

  def self.nick
    'short'
  end

  def created_at
    zone.local_to_utc(attribute_get(:created_at))
  end
end

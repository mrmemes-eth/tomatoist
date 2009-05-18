class LongBreak < Timer
  DURATION = 15*60

  property :duration, Integer, :default => DURATION

  def created_at
    zone.local_to_utc(attribute_get(:created_at))
  end

  def name
    'Long Break'
  end
end

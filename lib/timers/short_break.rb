class ShortBreak < Timer
  DURATION = 5*60

  property :duration, Integer, :default => DURATION

  def created_at
    zone.local_to_utc(attribute_get(:created_at))
  end

  def name
    'Short Break'
  end
end

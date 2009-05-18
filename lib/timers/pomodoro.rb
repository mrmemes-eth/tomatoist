class Pomodoro < Timer
  DURATION = 25*60

  property :duration, Integer, :default => DURATION

  def created_at
    zone.local_to_utc(attribute_get(:created_at))
  end

  def name
    'Pomodoro'
  end
end

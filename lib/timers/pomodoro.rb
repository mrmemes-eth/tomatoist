class Pomodoro < Timer
  before :valid? do
    self.duration = 25*60
  end

  def self.label
    'Pomodoro'
  end

  def self.nick
    'pomo'
  end

  def created_at
    zone.local_to_utc(attribute_get(:created_at))
  end
end

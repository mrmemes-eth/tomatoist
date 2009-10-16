class LongBreak < Timer
  before :valid? do
    self.duration = 15*60
  end

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

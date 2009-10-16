class ShortBreak < Timer
  before :valid? do
    self.duration = 5*60
  end

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

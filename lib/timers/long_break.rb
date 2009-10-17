class LongBreak < Timer
  before :valid? do
    self.duration = 15*60
  end

  def created_at
    zone.local_to_utc(attribute_get(:created_at))
  end
end

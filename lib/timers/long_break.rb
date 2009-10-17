class LongBreak < Timer
  before :valid? do
    self.duration = 15*60
  end
end

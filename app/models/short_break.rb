class ShortBreak < Timer
  before :valid? do
    self.duration = 5*60
  end
end

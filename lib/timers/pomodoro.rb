class Pomodoro < Timer
  before :valid? do
    self.duration = 25*60
  end
end

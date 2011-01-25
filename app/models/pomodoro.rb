class Pomodoro < Timer
  set_callback(:validation, :before) do
    self.duration = 25*60
  end
end

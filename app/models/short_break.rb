class ShortBreak < Timer
  set_callback(:validation, :before) do
    self.duration = 5*60
  end
end

Fabricator(:session) do
  name 'abc'
end

Fabricator(:session_with_timers, from: :session) do
  timers(count: 5)
end

Fabricator(:timer) do
  session
  duration 25*60
end

Fabricator(:pomodoro, from: :timer, class_name: :Pomodoro)

Fabricator(:short_break, from: :timer, class_name: :ShortBreak)

Fabricator(:long_break, from: :timer, class_name: :LongBreak)

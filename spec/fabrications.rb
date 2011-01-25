Fabricator(:session) do
  name 'abc'
end

Fabricator(:session_with_timers, from: :session) do
  timers(count: 5)
end

Fabricator(:timer) do
  duration 25*60
end

Fabricator(:pomodoro)

Fabricator(:short_break)

Fabricator(:long_break)

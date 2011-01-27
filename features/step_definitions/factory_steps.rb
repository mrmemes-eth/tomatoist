Given /^(?:I have )?the following session:$/ do |table|
  Registry[:session] = ::Session.create(table.rows_hash)
end

Given /^that session has a pomodoro$/ do
  Registry[:pomodoro] = Registry[:session].timers.create({}, Pomodoro)
end

Given /^that session has a short break$/ do
  Registry[:short_break] = Registry[:session].timers.create({}, ShortBreak)
end

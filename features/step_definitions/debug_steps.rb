And 'I wait' do
  sleep(1)
end

And /I wait ([\.0-9]+) seconds/ do |time|
  sleep(time.to_f)
end

When 'I debug' do
  debugger
  true
end

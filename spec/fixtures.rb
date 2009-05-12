Session.fix {{
  :timers => 5.of { Timer.make }
}}
Session.fix(:timerless){{}}
Timer.fix {{
  :duration => 25*60
}}
Timer.fix(:with_session){{
  :duration => 25*60,
  :session => Session.gen(:timerless)
}}
Pomodoro.fix {{}}
ShortBreak.fix {{}}
LongBreak.fix {{}}

Session.fix {{
  :timers => 5.of { Timer.make }
}}
Timer.fix {{
  :duration => 25*60
}}

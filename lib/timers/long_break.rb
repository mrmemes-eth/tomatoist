class LongBreak < Timer
  property :duration, Integer, :default => 15*60 
  def name
    'Long Break'
  end
end

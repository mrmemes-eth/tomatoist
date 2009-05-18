class ShortBreak < Timer
  property :duration, Integer, :default => 5*60 
  def name
    'Short Break'
  end
end

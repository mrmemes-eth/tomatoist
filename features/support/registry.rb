class Registry
  def self.[](key)
    registry[key]
  end

  def self.[]=(key,value)
    registry[key] = value
  end

  private
  def self.registry
    @registry ||= {}
  end
end

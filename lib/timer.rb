require 'time'

class Timer
  include DataMapper::Resource

  property :id, Serial
  property :duration, Integer
  property :created_at, Time
  property :type, Discriminator

  belongs_to :session

  validates_present :duration, :session_id

  def self.label
    name.gsub(/([a-z])([A-Z])/,'\1 \2')
  end

  def self.nick
    label.split(/\s/).first.downcase
  end

  def self.recent
    all(:order => [:created_at.desc], :limit => 8)
  end

  def created_today?
    created_at.day == Time.now.day
  end

  def display_time
    if created_today?
      created_at.strftime('%l:%M%p')
    else
      created_at.strftime('%l:%M%p on %m/%d')
    end
  end

  def expiry
    created_at + duration
  end

  def expired?
    expiry.to_i < Time.now.to_i
  end

  def label
    self.class.label
  end
end


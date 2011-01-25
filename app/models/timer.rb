require 'time'

class Timer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :duration, type: Integer

  validates_presence_of :duration

  embedded_in :session

  scope :pomodoros, where(_type: 'Pomodoro')
  scope :short_breaks, where(_type: 'ShortBreak')
  scope :long_breaks, where(_type: 'LongBreak')
  scope :recent, order_by(:created_at.desc).limit(8)

  def self.label
    name.gsub(/([a-z])([A-Z])/,'\1 \2')
  end

  def self.nick
    label.split(/\s/).first.downcase
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

  def active?
    expiry.to_i >= Time.now.to_i
  end

  def label
    self.class.label
  end

  def remainder
    expiry.to_i - Time.now.to_i
  end
end

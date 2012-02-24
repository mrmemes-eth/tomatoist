class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :custom, type: String
  field :created_at, type: DateTime
  field :updated_at, type: DateTime

  validates_uniqueness_of :name
  validates_uniqueness_of :custom, if: -> { custom.present? }

  embeds_many :timers

  set_callback :create, :before, :generate_name

  SHORTS_TIL_LONG = 3

  def self.retrieve(session)
    any_of({name: session}, {custom: session})[0] || create(custom: session)
  end

  def custom=(name)
    self[:custom] = sluggify(name)
  end

  def display_name
    custom || name
  end

  def iteration_start_timer
    last_long = timers.long_breaks.last
    last_long ? last_long : timers.first
  end

  def iteration_short_breaks_count
    return 0 unless iteration_start_timer
    timers.short_breaks.where(:created_at.gte => iteration_start_timer.created_at).count
  end

  def next_timer
    case
    when timers.empty?, [ShortBreak,LongBreak].include?(timers.last.class)
      Pomodoro
    when iteration_short_breaks_count < SHORTS_TIL_LONG  ; ShortBreak
    when iteration_short_breaks_count >= SHORTS_TIL_LONG ; LongBreak
    end
  end

  def recent_timers
    timers.desc(:created_at).recent
  end

  def reset!
    timers.clear
  end

  protected

  def generate_name
    self.name = Session.next_name
  end

  def self.next_name
    (last ? last.name : 'z').succ!
  end

  def sluggify(name)
    return unless name.present?
    name.gsub!(/\s/,'_')
    name.gsub!(/[\W]/,'')
    name.downcase
  end

end


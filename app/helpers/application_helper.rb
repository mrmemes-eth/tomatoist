Tomatoist.helpers do
  def root_path
    "/"
  end

  def session_path(session)
    "/#{session.display_name}"
  end

  def session_reset_path(session)
    "/#{session.display_name}/reset"
  end

  def session_timers_path(session)
    "#{session_path(session)}/timers"
  end

  def timer
    return nil unless @session
    @timer ||= @session.timers.last
  end

  def next_timer
    @next_timer ||= @session.next_timer
  end

  def timer_class(session,type)
    case
    when session.next_timer == type; 'next'
    when session.timers.last.kind_of?(type); 'current'
    end
  end

  def body_class(timer)
    'expired' if timer && timer.expired?
  end

  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    case distance_in_minutes
      when 0..1
        return (distance_in_minutes == 0) ? 'less than a minute' : '1 minute' unless include_seconds
        case distance_in_seconds
          when 0..4   then 'less than 5 seconds'
          when 5..9   then 'less than 10 seconds'
          when 10..19 then 'less than 20 seconds'
          when 20..39 then 'half a minute'
          when 40..59 then 'less than a minute'
          else             '1 minute'
        end

      when 2..44           then "#{distance_in_minutes} minutes"
      when 45..89          then 'about 1 hour'
      when 90..1439        then "about #{(distance_in_minutes.to_f / 60.0).round} hours"
      when 1440..2879      then '1 day'
      when 2880..43199     then "#{(distance_in_minutes / 1440).round} days"
      when 43200..86399    then 'about 1 month'
      when 86400..525599   then "#{(distance_in_minutes / 43200).round} months"
      when 525600..1051199 then 'about 1 year'
      else                      "over #{(distance_in_minutes / 525600).round} years"
    end
  end
end

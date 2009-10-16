module DingHelpers
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
    @timer ||= @session.last_timer
  end

  def next_timer
    @next_timer ||= @session.next_timer
  end

  def timer_class(session,type)
    case
    when session.next_timer == type; 'next'
    when session.last_timer.kind_of?(type); 'current'
    end
  end
end

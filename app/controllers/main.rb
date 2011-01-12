Tomatoist.controller do
  def session
    @session ||= Session.retrieve(params[:session])
  end

  get '/' do
    redirect session_path(Session.create)
  end

  get '/faq' do
    haml(:faq, layout: false)
  end

  get '/:session/?' do
    @session = Session.retrieve(params[:session])
    haml :timers
  end

  get '/:session/status.js/?' do
    if session && (timer = session.last_timer)
      { expired: timer.expired? }.to_json
    end
  end

  put '/:session' do
    session.update(custom: params[:custom])
    redirect session_path(session.reload)
  end

  put '/:session/reset' do
    session.reset!
    redirect session_path(session.reload)
  end

  post '/:session/timers' do
    session.timers.create(type: params[:type])
    redirect session_path(session)
  end
end

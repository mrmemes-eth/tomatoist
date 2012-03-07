Tomatoist.controller do
  get '/' do
    if cookies.has_key?(:current_session)
      redirect "/#{cookies[:current_session]}"
    else
      redirect session_path(Session.create)
    end
  end

  get '/faq' do
    render(:haml, :faq, layout: :application)
  end

  get '/:session/?' do
    return if params[:session] == 'null'
    cookies.permanent[:current_session] = params[:session]
    @session = Session.retrieve(params[:session])
    render(:haml, :timers, layout: :application)
  end

  get '/:session/status.js/?' do
    session = Session.retrieve(params[:session])
    if session && (timer = session.timers.last)
      { expired: timer.expired? }.to_json
    end
  end

  put '/:session' do
    session = Session.retrieve(params[:session])
    session.update_attributes(custom: params[:custom])
    redirect session_path(session.reload)
  end

  put '/:session/reset' do
    session = Session.retrieve(params[:session])
    session.reset!
    redirect session_path(session.reload)
  end

  post '/:session/timers' do
    session = Session.retrieve(params[:session])
    session.timers.create({}, params[:type].constantize)
    redirect session_path(session)
  end
end

require 'rubygems'
require 'sinatra/base'
require 'haml'

require 'config/environment'

class Ding < Sinatra::Default
  enable :raise_errors

  helpers do
    include DingHelpers
  end

  get '/' do
    redirect session_path(Session.create)
  end

  get '/faq' do
    haml(:faq, :layout => false)
  end

  get '/:session/?' do
    @session = Session.retrieve(params[:session])
    haml :timers
  end

  get '/:session/status.js/?' do
    session = Session.retrieve(params[:session])
    if session && (timer = session.last_timer)
      {:expired => timer.expired?}.to_json
    end
  end

  put '/:session' do
    session = Session.retrieve(params[:session])
    session.update_attributes(:custom => params[:custom])
    redirect session_path(session.reload)
  end

  put '/:session/reset' do
    session = Session.retrieve(params[:session])
    session.reset!
    redirect session_path(session.reload)
  end

  post '/:session/timers' do
    session = Session.retrieve(params[:session])
    session.timers.create(:type => params[:type], :offset => params[:offset])
    redirect session_path(session)
  end
end


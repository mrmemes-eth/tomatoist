require 'rubygems'
require 'sinatra'

require 'environment'

helpers do
  def root_path
    "/"
  end
  def session_path(session)
    "/#{session.name}"
  end
  def session_timers_path(session)
    "#{session_path(session)}/timers"
  end
end

get '/' do
  redirect session_path(Session.create)
end

get '/:session' do
  @session = Session.retrieve(params[:session])
  redirect root_path unless @session
  haml :timers
end

put '/:session' do
  session = Session.retrieve(params[:session])
  session.update_attributes(:custom => params[:custom])
  redirect session_path(session)
end

post '/:session/timers' do
  session = Session.retrieve(params[:session])
  session.timers.create(:timer => params[:timer])
  redirect session_path(session)
end


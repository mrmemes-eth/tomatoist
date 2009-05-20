require 'rubygems'
require 'sinatra'

require 'environment'

helpers do
  def root_path
    "/"
  end
  def session_path(session)
    "/#{session.display_name}"
  end
  def session_timers_path(session)
    "#{session_path(session)}/timers"
  end
  def timer
    @timer ||= @session.last_timer
  end
  def next_timer
    @next_timer ||= @session.next_timer
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
  session.timers.create(:type => params[:type], :offset => params[:offset])
  redirect session_path(session)
end


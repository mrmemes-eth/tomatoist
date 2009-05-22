require 'rubygems'
require 'sinatra/base'
require 'haml'

require 'environment'

class Ding < Sinatra::Default
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
      return nil unless @session
      @timer ||= @session.last_timer
    end
    def next_timer
      @next_timer ||= @session.next_timer
    end
    def new_timer_class(session,type)
      session.next_timer == type ? 'next' : nil
    end
  end

  get '/' do
    redirect session_path(Session.create)
  end

  get '/faq' do
    haml(:faq)
  end

  get '/:session/?' do
    @session = Session.retrieve(params[:session])
    redirect root_path unless @session
    haml :timers
  end

  put '/:session' do
    session = Session.retrieve(params[:session])
    session.update_attributes(:custom => params[:custom])
    redirect session_path(session.reload)
  end

  post '/:session/timers' do
    session = Session.retrieve(params[:session])
    session.timers.create(:type => params[:type], :offset => params[:offset])
    redirect session_path(session)
  end
end


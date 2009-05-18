require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Ding' do
  include Sinatra::Test

  context "a PUT to /:session" do
    before do
      @session = Session.gen(:name => "af")
      Session.stub!(:retrieve).and_return(@session)
    end

    it "should rename the Session" do
      put '/af', :custom => "voxdolo"
      Session.retrieve("voxdolo").should == @session
    end

    it "should redirect to the session path after creation" do
      put '/af', :custom => 'voxdolo'
      response.headers['Location'].should == "/#{@session.custom}"
    end

  end

  context "a POST to /:session/timers" do
    before do
      @session = Session.gen
      Session.stub!(:first).and_return(@session)
    end
    it "creates a new timer with time zone offset" do
      post '/af/timers', :type => 'ShortBreak', :offset => '-4'
      @session.timers.last.offset.should == '-4'
    end
    it "creates a new short break timer" do
      post '/af/timers', :type => 'ShortBreak'
      @session.timers.any?{|t| t.duration == 5*60 }.should be_true
    end
    it "creates a new long break timer" do
      post '/af/timers', :type => 'LongBreak'
      @session.timers.any?{|t| t.duration == 15*60 }.should be_true
    end
    it "creates a new pomodoro timer" do
      post '/af/timers', :type => 'Pomodoro'
      @session.timers.any?{|t| t.duration == 25*60 }.should be_true
    end
    it "redirects to the session" do
      post '/af/timers', :type => 'Pomodoro'
      response.headers['Location'].should == "/#{@session.name}"
    end
  end

  context "a GET to '/'" do
    before do
      @session = Session.gen
      Session.stub!(:create).and_return(@session)
    end

    it "redirects you to a new session" do
      get '/'
      response.headers['Location'].should == "/#{@session.name}"
    end
  end

  context "a GET to '/:session'" do
    before do
      @session = Session.gen
    end

    it "redirects to root when specified session does not exist" do
      Session.stub!(:retrieve).and_return(nil)
      get '/whateva'
      response.headers['Location'].should == "/"
    end

    it "retrieves the specified session" do
      Session.should_receive(:retrieve).with('foobar')
      get '/foobar'
    end
  end
end


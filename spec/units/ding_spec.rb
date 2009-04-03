require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Ding' do
  include Sinatra::Test

  context "a POST to /:session/timers" do
    before do
      @session = Session.gen
      Session.stub!(:first).and_return(@session)
    end
    it "creates a new short break timer" do
      post '/af/timers', :timer => 'short'
      @session.timers.any?{|t| t.duration == 5*60 }.should be_true
    end
    it "creates a new long break timer" do
      post '/af/timers', :timer => 'long'
      @session.timers.any?{|t| t.duration == 15*60 }.should be_true
    end
    it "creates a new pomodoro timer" do
      post '/af/timers', :timer => 'pomo'
      @session.timers.any?{|t| t.duration == 25*60 }.should be_true
    end
    it "redirects to the session" do
      post '/af/timers', :timer => 'pomo'
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
      Session.stub!(:first).and_return(@session)
    end

    it "redirects to root when specified session does not exist" do
      Session.stub!(:first).and_return(nil)
      get '/whateva'
      response.headers['Location'].should == "/"
    end

    it "retrieves the specified session" do
      Session.should_receive(:first).with(:name => 'foobar')
      get '/foobar'
    end
  end
end


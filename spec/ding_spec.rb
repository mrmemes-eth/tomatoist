require File.join(File.dirname(__FILE__), '..', 'helper')

describe 'Ding' do
  context "a PUT to /:session" do
    before do
      @session = Session.gen
      Session.stub!(:retrieve).and_return(@session)
    end

    it "should rename the Session" do
      put "/#{@session.name}", :custom => "voxdolo"
      Session.retrieve("voxdolo").should == @session
    end

    it "should redirect to the session path after creation" do
      put "/#{@session.name}", :custom => 'voxdolo'
      redirected_to.should == "/#{@session.custom}"
    end

    context "when the custom name is taken" do
      before do
        Session.gen(:custom => 'voxdolo')
      end

      it "redirects to the current sessions path" do
        put "/#{@session.name}", :custom => 'voxdolo'
        redirected_to.should == "/#{@session.name}"
      end
    end
  end

  context "a PUT to /:session/reset" do
    before do
      @session = Session.gen
      Session.stub!(:retrieve).and_return(@session)
    end
    it "should reset the session" do
      @session.should_receive(:reset!)
      put "/#{@session.name}/reset"
    end
    it "redirects to the current sessions path" do
      put "/#{@session.name}/reset"
      redirected_to.should == "/#{@session.name}"
    end
  end

  context "a POST to /:session/timers" do
    before do
      @session = Session.gen
      Session.stub!(:first).and_return(@session)
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
      redirected_to.should == "/#{@session.name}"
    end
  end

  context "a GET to '/'" do
    before do
      @session = Session.gen
      Session.stub!(:create).and_return(@session)
    end

    it "redirects you to a new session" do
      get '/'
      redirected_to.should == "/#{@session.name}"
    end
  end

  context "a GET to '/:session'" do
    before do
      @session = Session.gen
    end

    it "retrieves the specified session" do
      Session.should_receive(:retrieve).with('foobar').and_return(@session)
      get '/foobar'
    end
  end

  context "a GET to '/:session/status.js'" do
    before do
      @session = Session.gen
    end

    it "has an empty body when the session does not exist" do
      Session.stub!(:retrieve).and_return(nil)
      get '/whateva/status.js'
      body.should be_empty
    end

    context "retrieves the specified session" do
      it 'has an empty body when there is no last timer' do
        Session.stub!(:retrieve => stub(:last_timer => nil))
        get '/foobar/status.js'
        body.should be_empty
      end

      it 'responds with json' do
        timer = stub(:expired? => true)
        Session.stub!(:retrieve => stub(:last_timer => timer))
        get '/foobar/status.js'
        JSON.parse(body)['expired'].should be_true
      end
    end
  end

  describe "#timer_class" do
    before(:each) do
      @session = Session.gen(:timerless)
      @pomo    = Pomodoro.gen(:session => @session)
      @long    = LongBreak.gen(:session => @session)
    end

    it "returns next when type is the same as the next timer" do
      timer_class(@session,Pomodoro).should == 'next'
    end

    it "returns current when type is the same as the current timer" do
      timer_class(@session,LongBreak).should == 'current'
    end

    it "returns nil elsewise" do
      timer_class(@session,ShortBreak).should be_nil
    end
  end
end


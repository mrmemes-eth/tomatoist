require File.join(File.dirname(__FILE__), '..', 'helper')

describe Session do
  after do
    Session.all.destroy!
  end

  it "instantiates succesfully" do
    Session.new.should be_an_instance_of(Session)
  end

  it "generates a name" do
    Session.create.name.should =~ /\w{2,}/
  end

  it "suggests the next session name" do
    Session.next_name.should be_kind_of(String)
  end

  it "has timers" do
    session = Session.gen
    session.timers.all?{|t| t.kind_of?(Timer) }.should be_true
  end

  context "validating the custom name" do
    it "requires it to be unique" do
      Session.gen(:custom => 'foo')
      Session.gen(:custom => 'foo').errors.keys.should include(:custom)
    end
    it "doesn't validate if it's blank" do
      # nil custom name, successive would trigger unique guard
      Session.gen
      Session.gen.errors.should be_empty
    end
  end

  context "when returning a session name" do
    it "defaults to the session name" do
      session = Session.gen
      session.display_name.should == session.name
    end
    it "yields the custom name when it's present" do
      session = Session.gen(:custom => "voxdolo")
      session.display_name.should == session.custom
    end
  end

  context "setting the custom name" do
    it "does not alter 'safe' names" do
      session = Session.gen(:custom => 'voxdolo')
      session.custom.should == 'voxdolo'
    end
    it "replaces spaces with underscores" do
      session = Session.gen(:custom => 'voxdolo rawks')
      session.custom.should == 'voxdolo_rawks'
    end
    it "removes non-word characters with" do
      session = Session.gen(:custom => 'voxdolo rawks')
      session.custom.should == 'voxdolo_rawks'
    end
    it "'cleanses' unsafe names" do
      session = Session.gen(:custom => 'voxdolo is Mr. Awesome! Yeah!!!')
      session.custom.should == 'voxdolo_is_mr_awesome_yeah'
    end
  end

  it "retrieves the most recently created Session" do
    Session.gen
    Session.gen
    session = Session.gen
    Session.last.should == session
  end

  it "retrieves the most recently created timer" do
    session = Session.gen(:timerless)
    Timer.gen(:session => session)
    timer = Timer.gen(:session => session)
    session.last_timer.should == timer
  end

  it "retrieves the first timer" do
    session = Session.gen(:timerless)
    pomodoro = Pomodoro.gen(:session => session)
    session.first_timer.should == pomodoro
  end

  context "retrieving a session" do
    it "by it's generated name succeeds" do
      session = Session.gen
      Session.retrieve(session.name).should == session
    end

    it "by it's custom name succeeds" do
      session = Session.gen(:custom => "voxdolo")
      Session.retrieve(session.custom).should == session
    end
  end

  it "retrieves the last long timer" do
    session = Session.gen(:timerless)
    LongBreak.gen(:session => session)
    long = LongBreak.gen(:session => session)
    session.last_long.should == long
  end

  context "retrieving the timer that started the set" do
    before do
      @session = Session.gen(:timerless)
    end
    it "is the last long timer when a long timer is present" do
      long = LongBreak.gen(:session => @session)
      @session.set_start_timer.should == long
    end
    it "is the first timer when there has been no long timer" do
      pomodoro = Pomodoro.gen(:session => @session)
      @session.set_start_timer.should == pomodoro
    end
  end

  # the following is predicated upon the following scheme:
  # pomo - short - pomo - short - pomo - short - pomo - long
  context "suggesting the next timer's type" do
    before do
      @session = Session.gen(:timerless)
    end
    context "when there are no timers" do
      it "recommends a Pomodoro" do
        @session.next_timer.should == Pomodoro
      end
    end
    context "when the first timer was a pomodoro" do
      it "recommends a ShortBreak" do
        Pomodoro.gen(:session => @session)
        @session.next_timer.should == ShortBreak
      end
    end
    context "when the last timer was a break" do
      it "recommends a Pomodoro" do
        ShortBreak.gen(:session => @session)
        @session.next_timer.should == Pomodoro
      end
    end
    context "when the last timer was not a break" do
      before do
        LongBreak.gen(:session => @session)
        ShortBreak.gen(:session => @session)
        ShortBreak.gen(:session => @session)
      end
      context "and there are 2 or less shorts since the last long" do
        it "recommends a short break" do
          Pomodoro.gen(:session => @session)
          @session.next_timer.should == ShortBreak
        end
      end
      context "and there are 3 shorts since the last long" do
        it "recommends a long break" do
          ShortBreak.gen(:session => @session)
          Pomodoro.gen(:session => @session)
          @session.next_timer.should == LongBreak
        end
      end
    end

  context "counting the number of short breaks since a long break" do
    before do
      @session = Session.gen(:timerless)
    end
    it "Reports 0 when there are none" do
      @session.current_short_breaks_count.should == 0
    end
    it "Reports 1 when there is 1" do
      ShortBreak.gen(:session => @session)
      @session.current_short_breaks_count.should == 1
    end
    it "Reports 2 when there is 2" do
      ShortBreak.gen(:session => @session)
      ShortBreak.gen(:session => @session)
      @session.current_short_breaks_count.should == 2
    end
    it "Reports 3 when there is 3" do
      ShortBreak.gen(:session => @session)
      ShortBreak.gen(:session => @session)
      ShortBreak.gen(:session => @session)
      @session.current_short_breaks_count.should == 3
    end
    it "Reports 4 when there is 4" do
      ShortBreak.gen(:session => @session)
      ShortBreak.gen(:session => @session)
      ShortBreak.gen(:session => @session)
      ShortBreak.gen(:session => @session)
      @session.current_short_breaks_count.should == 4
    end
    it "Reports 0 after a long break" do
      LongBreak.gen(:session => @session)
      @session.current_short_breaks_count.should == 0
    end
    it "Reports 1 when there is 1 short after a long" do
      LongBreak.gen(:session => @session)
      ShortBreak.gen(:session => @session)
      @session.current_short_breaks_count.should == 1
    end
  end

end


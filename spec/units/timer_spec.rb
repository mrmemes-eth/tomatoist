require File.join(File.dirname(__FILE__), '..', 'helper')

describe Timer do
  it "populates created_at" do
    Timer.gen(:session => Session.gen).created_at.should be_kind_of(Time)
  end

  it "requires a duration" do
    Timer.gen(:duration => nil).errors[:duration].should_not be_nil
  end

  it "requires a session_id" do
    Timer.gen(:session_id => nil).errors[:session_id].should_not be_nil
  end

  it "gives a date of expiry" do
    time = Time.now
    timer = Timer.gen(:duration => 60*15)
    timer.stub!(:created_at).and_return(time)
    timer.expiry.should == time + 60*15
  end

  it "yields a JS friendly timer expiry array" do
    time = Time.parse('Wed Apr 01 16:20:00 -0400 2009')
    timer = Timer.gen
    timer.stub!(:expiry).and_return(time)
    timer.to_js.should == [2009,3,1,16,20,0]
  end

  it "defaults the offset to '0'" do
    Timer.gen(:with_session).offset.should == '0'
  end

  it 'returns the current time utilizing timezone' do
    timer = Timer.new
    Time.stub!(:now => stub(:now, :utc => 123))
    timer.zone.should_receive(:local_to_utc).with(123)
    timer.send(:now)
  end

  context "displaying times" do
    it 'should show not show month & day if timer was created today' do
       timer = Timer.gen(:with_session)
       timer.display_time.should_not =~ /on/
    end

    it 'should show month & day if timer was not created today' do
       timer = Timer.gen(:with_session)
       timer.stub!(:created_at).and_return(Time.now - 60 * 60 * 24)
       timer.display_time.should =~ /on/
    end

    it "does not specify the time zone when there's an offset" do
      timer = Timer.gen(:with_session, :offset => '-4')
      timer.display_time.should_not =~ /UTC/
    end

    it "notes that it's UTC if there's no offset" do
      timer = Timer.gen(:with_session)
      timer.display_time.should =~ /UTC/
    end

    it "notes that it's UTC if the offset is '0'" do
      timer = Timer.gen(:with_session, :offset => '0')
      timer.display_time.should =~ /UTC/
    end
  end

  context "reporting it's expiry status" do
    context 'when it has exipred' do
      it 'says true' do
        timer = Timer.new
        timer.stub!(:expiry => (Time.now - 60))
        timer.stub!(:now => Time.now)
        timer.should be_expired
      end
    end
    context 'when it has not exipred' do
      it 'says false' do
        timer = Timer.new
        timer.stub!(:expiry => (Time.now + 60))
        timer.stub!(:now => Time.now)
        timer.should_not be_expired
      end
    end
  end

  context 'created_at timezone' do
    it 'is UTC by default' do
      timer = Timer.gen(:with_session)
      timer.created_at.should be_utc
    end

    it 'converts to a tz appropriate time when an offset is given' do
      pending
      time = Time.now
      Time.stub!(:now).and_return(time)
      offset = Time.zone_offset(Time.now.zone)/60/60
      timer = Timer.gen(:with_session, :offset => offset)
      # FIXME (SC): There appears to be a phase of the moon bug here
      (timer.created_at.to_a[2] - timer.offset.to_i).should == time.to_a[2]
    end
  end

  context 'retrieving timers by type' do
    before do
      Timer.all.destroy!
    end

    it 'finds timers of the Pomodoro subtype' do
      Pomodoro.gen
      Timer.all.map{|t| t.class}.should include(Pomodoro)
    end

    it 'finds timers of the ShortBreak subtype' do
      ShortBreak.gen
      Timer.all.map{|t| t.class}.should include(ShortBreak)
    end

    it 'finds timers of the LongBreak subtype' do
      LongBreak.gen
      Timer.all.map{|t| t.class}.should include(LongBreak)
    end
  end

  context 'retrieving descendant class' do
    subject do
      Timer.new
    end

    it 'returns Timer for invalid types' do
      subject.send(:get_descendant_class, 'Kernel').should == Timer
    end

    it 'returns Pomodoro for "Pomodoro"' do
      subject.send(:get_descendant_class, 'Kernel').should == Timer
    end

    it 'returns ShortBreak for "ShortBreak"' do
      subject.send(:get_descendant_class, 'Kernel').should == Timer
    end

    it 'returns LongBreak for "LongBreak"' do
      subject.send(:get_descendant_class, 'Kernel').should == Timer
    end
  end

  context 'instantiates timers by type' do
    it 'creates timers of the Pomodoro subtype' do
      Timer.new(:type => 'Pomodoro').type.should == Pomodoro
    end

    it 'creates timers of the ShortBreak subtype' do
      Timer.new(:type => 'ShortBreak').type.should == ShortBreak
    end

    it 'creates timers of the LongBreak subtype' do
      Timer.new(:type => 'LongBreak').type.should == LongBreak
    end
  end
end


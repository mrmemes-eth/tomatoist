require File.join(File.dirname(__FILE__), '..', 'spec_helper')

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
  end

  context 'created_at timezone' do
    it 'is UTC by default' do
      timer = Timer.gen(:with_session)
      timer.created_at.should be_utc
    end
    it 'converts to a tz appropriate time when an offset is given' do
      time = Time.now
      Time.stub!(:now).and_return(time)
      offset = Time.zone_offset(Time.now.zone)/60/60
      timer = Timer.gen(:with_session, :offset => offset)
      (timer.created_at.to_a[2] - timer.offset.to_i).should == time.to_a[2]
    end
  end

  context 'creating named timers' do
    it 'creates a short timer' do
      Timer.new(:timer => 'short').duration.should == 5*60
    end
    it 'creates a long timer' do
      Timer.new(:timer => 'long').duration.should == 15*60
    end
    it 'creates a pomodoro timer' do
      Timer.new(:timer => 'pomo').duration.should == 25*60
    end
  end

  context 'retrieving a timers name' do
    it 'identifies a short timer' do
      Timer.gen(:duration => 5*60).name.should == 'Short Break'
    end
    it 'identifies a long timer' do
      Timer.gen(:duration => 15*60).name.should == 'Long Break'
    end
    it 'identifies a short timer' do
      Timer.gen(:duration => 25*60).name.should == 'Pomodoro'
    end
  end
end


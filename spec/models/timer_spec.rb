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

  describe "#remainder" do
    it 'returns the time remaining in the timer in seconds' do
      Time.stub(:now).and_return(Time.parse('12/30/09 10:15:00 EST'))
      t = Timer.gen(:session => nil)
      t.stub(:expiry).and_return(Time.parse('12/30/09 10:15:15 EST'))
      t.remainder.should == 15
    end
  end
end


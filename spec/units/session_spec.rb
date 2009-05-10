require File.join(File.dirname(__FILE__), '..', 'spec_helper')

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

end


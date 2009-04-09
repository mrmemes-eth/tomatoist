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

  it "should retrieve a session by name" do
    @session = Session.gen(:name => "voxdolo")
    Session.first(:name => "voxdolo").should == @session
  end

  it "finds the last generated name" do
    Session.gen
    Session.gen
    Session.last.name.should == "ab"
  end

  it "retrieves a session by it's generated name" do
    session = Session.gen
    Session.retrieve(session.name).should == session
  end

  it "retrieves a session by it's custom name" do
    session = Session.gen(:custom => "voxdolo")
    Session.retrieve(session.custom).should == session
  end

  it "has timers" do
    session = Session.gen
    session.timers.all?{|t| t.kind_of?(Timer) }.should be_true
  end

  context "when returning a session name" do
    it "defaults to the session name" do
      session = Session.gen(:name => "af")
      session.name.should == "af"
    end
    it "yields the custom name when it's present" do
      session = Session.gen(:custom => "voxdolo")
      session.name.should == "voxdolo"
    end
  end
end


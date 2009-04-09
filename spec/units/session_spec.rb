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

  it "has timers" do
    session = Session.gen
    session.timers.all?{|t| t.kind_of?(Timer) }.should be_true
  end
end


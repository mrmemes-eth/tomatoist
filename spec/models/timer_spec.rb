require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Timer do
  it "populates created_at" do
    Timer.gen.created_at.should_not be_nil
  end

  it "requires a duration" do
    Timer.gen(:duration => nil).should_not be_valid
  end

  it "requires a session_id" do
    Timer.gen(:session_id => nil).should_not be_valid
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
end


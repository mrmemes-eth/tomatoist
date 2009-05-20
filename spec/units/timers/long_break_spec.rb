require File.join(File.dirname(__FILE__), '..', '..', 'helper')

describe LongBreak do
  it "defaults duration to 900" do
    LongBreak.gen.duration.should == 900
  end
  it "reports it's name" do
    LongBreak.gen.name.should == 'Long Break'
  end
end

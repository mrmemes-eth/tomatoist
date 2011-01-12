require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe LongBreak do
  it "defaults duration to 900" do
    LongBreak.gen.duration.should == 900
  end
  it "reports it's label" do
    LongBreak.label.should == 'Long Break'
  end
end

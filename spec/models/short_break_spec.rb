require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe ShortBreak do
  it "defaults duration to 300" do
    ShortBreak.gen.duration.should == 300
  end
  it "reports it's name" do
    ShortBreak.label.should == 'Short Break'
  end
end

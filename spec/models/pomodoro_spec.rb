require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Pomodoro do
  it "defaults duration to 1500" do
    Pomodoro.gen.duration.should == 1500
  end
  it "reports it's name" do
    Pomodoro.label.should == 'Pomodoro'
  end
end

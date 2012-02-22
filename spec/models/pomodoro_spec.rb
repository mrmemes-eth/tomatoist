require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Pomodoro do
  subject { Fabricate(:pomodoro) }
  its(:duration) { should == 1500 }

  it "reports it's name" do
    Pomodoro.label.should == 'Pomodoro'
  end
end

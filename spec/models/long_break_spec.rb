require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe LongBreak do
  subject { Fabricate(:long_break) }
  its(:duration) { should == 900 }

  context "#label" do
    subject { LongBreak.label }
    it { should == 'Long Break' }
  end
end

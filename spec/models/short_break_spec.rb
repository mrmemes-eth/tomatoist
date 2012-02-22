require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe ShortBreak do
  subject { Fabricate(:short_break) }
  its(:duration) { should == 300 }

  it "reports it's name" do
    ShortBreak.label.should == 'Short Break'
  end
end

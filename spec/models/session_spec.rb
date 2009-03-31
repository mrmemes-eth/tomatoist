require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Session do
  after do
    Session.all.destroy!
  end
  it "should instantiate" do
    Session.new.should_not be_nil
  end
  it "should generate a name" do
    Session.create.name.should =~ /\w{2,}/
  end
  it "should find last generated name" do
    Session.gen
    Session.gen
    Session.last.name.should == "ab"
  end
end


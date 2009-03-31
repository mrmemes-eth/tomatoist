require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Session do
  it "should instantiate" do
    Session.new.should_not be_nil
  end
end


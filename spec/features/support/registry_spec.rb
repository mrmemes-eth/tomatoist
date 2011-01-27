require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')
require File.join(File.dirname(__FILE__), '..', '..', '..', 'features', 'support', 'registry')

describe Registry do
  describe ".[]" do
    subject { Registry[arg] }
    context "when there is an associated key" do
      let(:arg) { 'foo' }
      before{ Registry.instance_variable_set('@registry', { 'foo' => 'bar'  }) }
      it { should == 'bar' }
    end
    context "when there is no associated key" do
      let(:arg) { 'bar' }
      it { should be_nil }
    end
  end

  describe ".[]=" do
    subject{ Registry['foo'] }
    before { Registry['foo'] = 'bar' }
    it { should == 'bar' }
  end
end

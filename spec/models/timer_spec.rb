require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Timer do
  context "validations" do
    let(:timer){ Fabricate.build(:timer, params) }
    subject{ timer.tap(&:valid?).errors }
    context "requires duration" do
      let(:params) { { duration: nil } }
      it{ should include(:duration) }
    end
  end

  context "#display_time" do
    it 'should show not show month & day if timer was created today' do
       timer = Fabricate(:timer)
       timer.display_time.should_not =~ /on/
    end

    it 'should show month & day if timer was not created today' do
       timer = Fabricate(:timer)
       timer.stub!(:created_at).and_return(Time.now - 60 * 60 * 24)
       timer.display_time.should =~ /on/
    end
  end

  context "#expired?" do
    context 'when it has exipred' do
      it 'says true' do
        timer = Timer.new
        timer.stub!(expiry: (Time.now - 60))
        timer.stub!(now: Time.now)
        timer.should be_expired
      end
    end
    context 'when it has not exipred' do
      it 'says false' do
        timer = Timer.new
        timer.stub!(expiry: (Time.now + 60))
        timer.stub!(now: Time.now)
        timer.should_not be_expired
      end
    end
  end

  context "#expiry" do
    let(:time){ Time.now }
    let(:timer){ Fabricate(:timer, duration: 60*15) }
    before { timer.stub!(:created_at).and_return(time) }
    specify { timer.expiry.should == time + 60*15 }
  end

  describe "#remainder" do
    it 'returns the time remaining in the timer in seconds' do
      Time.stub(:now).and_return(Time.parse('2010-12-30 10:15:00 EST'))
      t = Fabricate(:timer)
      t.stub(:expiry).and_return(Time.parse('2010-12-30 10:15:15 EST'))
      t.remainder.should == 15
    end
  end
end

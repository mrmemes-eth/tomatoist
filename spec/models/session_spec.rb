require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Session do

  context "validations" do
    let(:session){ Fabricate.build(:session, params) }
    subject{ session.tap(&:valid?).errors }

    context 'custom name' do
      context 'requires it to be unique' do
        let(:params) { { custom: 'foo' } }
        before{ Fabricate(:session, custom: 'foo') }
        it { subject[:custom].should include('is already taken') }
      end

      context 'allows it to be blank' do
        let(:params) { { custom: nil } }
        it { should_not include(:custom) }
      end
    end
  end

  context "#before_create" do
    it "generates a name" do
      Session.create.name.should =~ /\w{2,}/
    end
  end

  describe ".last" do
    it "retrieves the most recently created Session" do
      Fabricate(:session)
      session = Fabricate(:session)
      Session.last.should == session
    end
  end

  context '.next_name' do
    subject{ Session.next_name }
    it { should be_kind_of(String) }

    context 'when the last name was abc' do
      before{ Session.stub(:last).and_return(stub(name: 'abc')) }
      it { should == 'abd' }
    end

    context 'when the last name was xyz' do
      before{ Session.stub(:last).and_return(stub(name: 'xyz')) }
      it { should == 'xza' }
    end
  end

  describe ".retrieve" do
    let!(:session) { Fabricate(:session, custom: 'boozle') }

    it "by it's generated name succeeds" do
      Session.retrieve(session.name).should == session
    end

    it "by it's custom name succeeds" do
      Session.retrieve('boozle').should == session
    end

    context 'when the custom name does not exist' do
      it 'creates a new session' do
        expect do
          Session.retrieve('quuz')
        end.to change(Session, :count).by(1)
      end

      it 'has the assigned custom name' do
        Session.retrieve('quuz').custom.should == 'quuz'
      end
    end
  end

  describe "#custom=" do
    context "when the name is 'safe'" do
      let(:session){ Fabricate.build(:session, custom: 'voxdolo') }
      it "does not alter 'safe' names" do
        session.custom.should == 'voxdolo'
      end
    end

    context "when the name contains spaces" do
      let(:session){ Fabricate.build(:session, custom: 'voxdolo rawks') }
      it "replaces them with underscores" do
        session.custom.should == 'voxdolo_rawks'
      end
    end

    context "when the name contains non-word characters" do
      let(:session){ Fabricate.build(:session, custom: 'voxdolo &rawks') }
      it "replaces them with underscores" do
        session.custom.should == 'voxdolo_rawks'
      end
    end

    context "when there are trailing non-word characters" do
      let(:session){ Fabricate.build(:session, custom: 'voxdolo rawks!!') }
      it "removes them" do
        session.custom.should == 'voxdolo_rawks'
      end
    end

    context 'putting it all together' do
      let(:session){ Fabricate.build(:session, custom: 'voxdolo is Mr. Awesome! Yeah!!!') }
      it "'cleanses' unsafe names" do
        session.custom.should == 'voxdolo_is_mr_awesome_yeah'
      end
    end
  end

  describe "#display_name" do
    context "when there is no custom name" do
      let(:session){ Fabricate.build(:session, name: 'bazz') }
      it "defaults to the session name" do
        session.display_name.should == 'bazz'
      end
    end
    context "when there is a custom name" do
      let(:session){ Fabricate.build(:session, custom: 'voxdolo') }
      it "yields the custom name" do
        session.display_name.should == 'voxdolo'
      end
    end
  end

  describe "#iteration_start_timer" do
    let(:session){ Fabricate(:session) }
    let!(:pomodoro) { Fabricate(:pomodoro, session: session) }
    subject { session.iteration_start_timer }

    context "when a long timer is present" do
      let!(:long) { Fabricate(:long_break, session: session) }
      it { should == long }
    end

    context "when there has been no long timer" do
      it { should == pomodoro }
    end
  end

  # the following is predicated upon the following scheme:
  # pomo - short - pomo - short - pomo - short - pomo - long
  describe "#next_timer" do

    let(:session){ Fabricate.build(:session) }
    subject{ session.next_timer }

    context "when there are no timers" do
      it { should == Pomodoro }
    end

    context "when the first and only timer is a pomodoro" do
      before { Fabricate(:pomodoro, session: session) }
      it { should == ShortBreak }
    end

    context "when the last timer was a break" do
      before { Fabricate(:short_break, session: session) }
      it { should == Pomodoro }
    end

    context "when the last timer was not a break" do
      before do
        Fabricate(:long_break, session: session)
        Fabricate(:short_break, session: session)
        Fabricate(:short_break, session: session)
      end

      context "and there are 2 or less shorts since the last long" do
        before { Fabricate(:pomodoro, session: session) }
        it { should == ShortBreak }
      end

      context "and there are 3 shorts since the last long" do
        before do
          Fabricate(:short_break, session: session)
          Fabricate(:pomodoro, session: session)
        end
        it { should == LongBreak }
      end
    end

    context "when there has been a full cycle" do
      before do
        Fabricate(:pomodoro, session: session, created_at: 8.minutes.ago)
        Fabricate(:short_break, session: session, created_at: 7.minutes.ago)
        Fabricate(:pomodoro, session: session, created_at: 6.minutes.ago)
        Fabricate(:short_break, session: session, created_at: 5.minutes.ago)
        Fabricate(:pomodoro, session: session, created_at: 4.minutes.ago)
        Fabricate(:short_break, session: session, created_at: 3.minutes.ago)
        Fabricate(:pomodoro, session: session, created_at: 2.minutes.ago)
        Fabricate(:long_break, session: session, created_at: 1.minute.ago)
        Fabricate(:pomodoro, session: session)
      end
      it { should == ShortBreak }
    end
  end

  describe "#iteration_short_breaks_count" do
    let(:session){ Fabricate.build(:session) }
    subject{ session.iteration_short_breaks_count }

    context 'when there are no short breaks' do
      it { should == 0 }
    end

    context 'when there is 1 short break' do
      before { Fabricate(:short_break, session: session) }
      it { should == 1 }
    end

    context 'when there have been 2 short breaks' do
      before { 2.times{ Fabricate(:short_break, session: session) } }
      it { should == 2 }
    end

    context 'when there have been 3 short breaks' do
      before { 3.times{ Fabricate(:short_break, session: session) } }
      it { should == 3 }
    end

    context 'when there have been 4 short breaks' do
      before { 4.times{ Fabricate(:short_break, session: session) } }
      it { should == 4 }
    end

    context 'when the most recent timer is a long break' do
      before { Fabricate(:long_break, session: session) }
      it { should == 0 }
    end
    context 'when there has been 1 short break after a long break' do
      before do
        Fabricate(:long_break, session: session)
        Fabricate(:short_break, session: session)
      end
      specify { should == 1 }
    end
  end

  describe "#reset!" do
    let(:session) { Fabricate(:session_with_timers) }
    subject{ session.timers }
    before { session.reset! }
    it { should be_empty }
  end
end

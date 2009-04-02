require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Ding' do
  include Sinatra::Test

  context "a GET to '/'" do
    before do
      @session = Session.gen
      Session.stub!(:create).and_return(@session)
    end

    it "redirects you to a new session" do
      get '/'
      response.headers['Location'].should == "/#{@session.name}"
    end
  end

  context "a GET to '/:session'" do
    before do
      @session = Session.gen
      Session.stub!(:first).and_return(@session)
    end

    it "redirects to root when specified session does not exist" do
      Session.stub!(:first).and_return(nil)
      get '/whateva'
      response.headers['Location'].should == "/"
    end

    it "retrieves the specified session" do
      Session.should_receive(:first).with(:name => 'foobar')
      get '/foobar'
    end
  end
end


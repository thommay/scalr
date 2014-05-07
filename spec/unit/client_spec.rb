require 'spec_helper'

describe ScalrApi::APIError do
  let(:key) { 'somekey' }
  let(:url) { 'https://localhost' }
  let(:params) { { Version: '2.3.0', AuthVersion: 3, EnvID: 3, Action: 'EnvironmentsList', KeyID: key } }
  let(:sig) { 'chumpchange' }

  let(:conn) do
    Faraday::Connection.new(url) do |f|
      f.use described_class
      f.use VCR::Middleware::Faraday
      f.adapter Faraday.default_adapter
    end
  end

  let(:client) { ScalrApi::Client.new }

  before :each do
    ScalrApi.configure do |c|
      c.key = key
      c.url = url
    end
  end

  it 'should not raise for a valid request' do
    vcr_in_time('valid_req', record: :once, erb: { sig: sig, key: key }) do
      time = client.timestamp
      params[:TimeStamp] = time
      params[:Signature] = sig
      expect { conn.get('/api/api.php', params) }.not_to raise_error
    end
  end

  it 'should raise for an error response' do
    vcr_in_time('no_auth') do
      expect { conn.get('/api/api.php', params) }
        .to raise_error(ScalrApi::ResponseError, /^Signature/)
    end
  end
end

describe ScalrApi::Client do
  let(:key) { 'somekey' }
  let(:secret) { 'myreallysecuresecret' }
  let(:url) { 'https://localhost' }

  before :each do
    ScalrApi.configure do |c|
      c.key = key
      c.secret = secret
      c.url = url
    end
  end

  it { should respond_to(:get) }
  it { should_not respond_to(:post) }

  describe '#timestamp' do
    it { should respond_to(:timestamp) }

    it 'should return a valid timestamp' do
      expect(subject.timestamp).to eql(Time.now.getgm.iso8601)
    end
  end

  describe '#sanitize_params' do
    it { should respond_to(:sanitize_params).with(1).arguments }

    it 'should convert symbols to strings' do
      expect(subject.sanitize_params(action: "foo"))
        .to eql({'action' => "foo"})
    end

    it 'should not sanitize normal params' do
      expect(subject.sanitize_params('action' => "foo"))
        .to eql({'action' => "foo"})
    end

    it 'should convert a truthy value to 1' do
      expect(subject.sanitize_params('action' => true))
        .to eql({'action' => 1})
    end

    it 'should convert a falsey value to 0' do
      expect(subject.sanitize_params('action' => false))
        .to eql({'action' => 0})
    end

    it 'should convert a hash to a URL array' do
      expect(subject.sanitize_params('action' => {'a' => 'b'}))
        .to eql({'action[a]' => 'b'})
      expect(subject.sanitize_params('action' => {'a' => 'b', 'c' => 'd'}))
        .to eql({'action[a]' => 'b', 'action[c]' => 'd'})
    end

    it 'should cope with all of the above' do
      expect(subject.sanitize_params('truthy' => true,
                                     'foo' => 'val', 'action' => {'a' => 'b'}))
        .to eql({'truthy' => 1, 'foo' => 'val', 'action[a]' => 'b'})
    end
  end

  describe '#sig' do
    let(:ts) { '2014-03-31T13:37:50Z' }

    it { should respond_to(:sig).with(2).arguments }

    it 'should return a consistent signature' do
      expect(subject.sig('FarmsList', ts))
        .to eql '9kEIyp+B1BNUWaYCXppy57z8q9HsbMlSAhd46D2e2aQ='
    end

    it 'should vary based on action' do
      expect(subject.sig('FarmList', ts))
        .to_not eql '9kEIyp+B1BNUWaYCXppy57z8q9HsbMlSAhd46D2e2aQ='
    end

    it 'should vary based on timestamp' do
      expect(subject.sig('FarmsList', '2014-03-30T13:37:50Z'))
        .to_not eql '9kEIyp+B1BNUWaYCXppy57z8q9HsbMlSAhd46D2e2aQ='
    end
  end

  describe '#action' do
    it { should respond_to(:action).with(3).arguments }

# let(:url) { 'https://ecoslab.karmalab.net' }
# let(:key) { 'f1c08edc5245b07d' }
# let(:secret) { 'EmBDHCl3W+d8RrjIvtLT5pAcXOSMf+B965d9trw3mzr5PBO5CxmKaAqnnzB3HVMusM7yDVYWuqePwP+LT4kN2/BxP+uxqcchEqxvATXA29zfkcNBn7a5uxXOXP5IbIU0' }


    before(:each) do
      ScalrApi.configuration.environment = 3
      Timecop.freeze "2014-03-31T14:59:38Z"
      allow(subject).to receive(:sig).with('EnvironmentsList', '2014-03-31T14:59:38Z').and_return("M+koCAitGQJtRgbX+7DRpww4HtlS6tDYu2DERpa3fbs=")
    end

    it "should get a timestamp" do
      vcr_in_time('action_test') do
        allow(subject).to receive(:timestamp).and_return("2014-03-31T14:59:38Z")
        subject.action('EnvironmentsList')
      end
    end

    it "should get a signature" do
      vcr_in_time('action_test') do
        allow(subject).to receive(:sig).with('EnvironmentsList', '2014-03-31T14:59:38Z').and_return("M+koCAitGQJtRgbX+7DRpww4HtlS6tDYu2DERpa3fbs=")
        subject.action('EnvironmentsList')
      end
    end

    it 'should make a valid request' do
      subject.stub_chain(:client, :get).with('/api/api.php', {'Signature'=>"M+koCAitGQJtRgbX+7DRpww4HtlS6tDYu2DERpa3fbs=",
                                                              'Action'=>"EnvironmentsList", 'Version'=>"2.3.0", 'TimeStamp'=>"2014-03-31T14:59:38Z",
                                                              'KeyID'=>"somekey", 'AuthVersion'=>3, 'EnvID'=>3})
      subject.action('EnvironmentsList')
    end

    it 'should permit additional parameters' do
      subject.stub_chain(:client, :get).with('/api/api.php', {'Foo'=>"bar", 'Test'=>1, 'Signature'=>"M+koCAitGQJtRgbX+7DRpww4HtlS6tDYu2DERpa3fbs=",
                                                              'Action'=>"EnvironmentsList", 'Version'=>"2.3.0", 'TimeStamp'=>"2014-03-31T14:59:38Z",
                                                              'KeyID'=>"somekey", 'AuthVersion'=>3, 'EnvID'=>3})
      subject.action('EnvironmentsList', :get, Foo: 'bar', Test: true)
    end
  end

  describe '#get' do
    it { should respond_to(:get).with(2).arguments }

    it 'should call #action correctly' do
      allow(subject).to receive(:action).with('EnvironmentsList', :get, {}).and_return(OpenStruct.new(body: "FooBar"))
      expect(subject.get('EnvironmentsList')).to eql("FooBar")
    end
  end
end

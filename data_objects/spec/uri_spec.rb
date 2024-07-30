require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe DataObjects::URI do
  subject { described_class.parse(uri) }

  context 'parsing parts' do
    let(:uri) { 'mock://username:password@localhost:12345/path?encoding=utf8#fragment' }

    its(:scheme) { is_expected.to eq 'mock' }
    its(:user) { is_expected.to eq 'username' }
    its(:password) { is_expected.to eq 'password' }
    its(:host) { is_expected.to eq 'localhost' }
    its(:port) { is_expected.to eq 12_345 }
    its(:path) { is_expected.to eq '/path' }
    its(:query) { is_expected.to eq({'encoding' => 'utf8'}) }
    its(:fragment) { is_expected.to eq 'fragment' }

    it 'provides a correct string representation' do
      expect(subject.to_s).to eq 'mock://username@localhost:12345/path?encoding=utf8#fragment'
    end
  end

end

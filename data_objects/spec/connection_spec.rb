require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'stringio'

describe DataObjects::Connection do
  subject { connection }

  let(:connection) { described_class.new(uri) }

  after { connection.close }

  context 'should define a standard API' do
    let(:uri) { 'mock://localhost' }

    it { is_expected.to respond_to(:dispose) }
    it { is_expected.to respond_to(:create_command) }

    its(:to_s) { is_expected.to eq 'mock://localhost' }
  end

  describe 'initialization' do
    context 'with a connection uri as a Addressable::URI' do
      let(:uri) { Addressable::URI.parse('mock://localhost/database') }

      it { is_expected.to be_kind_of(DataObjects::Mock::Connection) }
      it { is_expected.to be_kind_of(DataObjects::Pooling)          }

      its(:to_s) { is_expected.to eq 'mock://localhost/database' }
    end

  end
end

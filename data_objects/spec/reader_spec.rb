require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe DataObjects::Reader do
  subject { command.execute_reader }

  let(:connection) { DataObjects::Connection.new('mock://localhost') }
  let(:command) { connection.create_command('SELECT * FROM example') }

  after { connection.close }

  context 'should define a standard API' do
    it { is_expected.to be_a(Enumerable) }
    it { is_expected.to respond_to(:close) }
    it { is_expected.to respond_to(:next!) }
    it { is_expected.to respond_to(:values) }
    it { is_expected.to respond_to(:fields) }
    it { is_expected.to respond_to(:each) }
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe DataObjects::Transaction do
  before :each do
    @connection = double('connection')
    expect(DataObjects::Connection).to receive(:new).with('mock://mock/mock').once.and_return(@connection)
    @transaction = DataObjects::Transaction.new('mock://mock/mock')
  end

  it 'has a HOST constant' do
    expect(DataObjects::Transaction::HOST).not_to eq nil?
  end

  describe '#initialize' do
    it 'provides a connection' do
      expect(@transaction.connection).to eq @connection
    end
    it 'provides an id' do
      expect(@transaction.id).not_to be_nil
    end
    it 'provides a unique id' do
      expect(DataObjects::Connection).to receive(:new).with('mock://mock/mock2').once.and_return(@connection)
      expect(@transaction.id).not_to eq DataObjects::Transaction.new('mock://mock/mock2').id
    end
  end
  describe '#close' do
    it 'closes its connection' do
      expect(@connection).to receive(:close).once
      expect { @transaction.close }.not_to raise_error
    end
  end
  %i(prepare commit_prepared rollback_prepared).each do |meth|
    it "raises NotImplementedError on #{meth}" do
      expect { @transaction.send(meth) }.to raise_error(NotImplementedError)
    end
  end
end

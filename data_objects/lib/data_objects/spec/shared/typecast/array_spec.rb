shared_examples 'supporting Array' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'passing an Array as a parameter in execute_reader' do
    before do
      @reader = @connection.create_command('SELECT * FROM widgets WHERE id in ?').execute_reader([2, 3, 4, 5])
    end

    after do
      @reader.close
    end

    it 'returns correct number of rows' do
      counter  = 0
      counter += 1 while @reader.next!
      expect(counter).to eq 4
    end
  end
end

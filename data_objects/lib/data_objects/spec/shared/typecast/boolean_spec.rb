shared_examples 'supporting Boolean' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a Boolean' do
    describe 'with manual typecasting' do
      before do
        @command = @connection.create_command('SELECT flags FROM widgets WHERE ad_description = ?')
        @command.set_types(TrueClass)
        @reader = @command.execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(FalseClass)
      end

      it 'returns the correct result' do
        expect(@values.first).to eq false
      end
    end

    describe 'with manual typecasting a true value' do
      before do
        @command = @connection.create_command('SELECT flags FROM widgets WHERE id = ?')
        @command.set_types(TrueClass)
        @reader = @command.execute_reader(2)
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(TrueClass)
      end

      it 'returns the correct result' do
        expect(@values.first).to be true
      end
    end

    describe 'with manual typecasting a nil value' do
      before do
        @command = @connection.create_command('SELECT flags FROM widgets WHERE id = ?')
        @command.set_types(TrueClass)
        @reader = @command.execute_reader(4)
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(NilClass)
      end

      it 'returns the correct result' do
        expect(@values.first).to be_nil
      end
    end
  end

  describe 'writing an Boolean' do
    before do
      @reader = @connection.create_command('SELECT id FROM widgets WHERE flags = ?').execute_reader(true)
      @reader.next!
      @values = @reader.values
    end

    after do
      @reader.close
    end

    it 'returns the correct entry' do
      expect(@values.first).to eq 2
    end
  end
end

shared_examples 'supporting Boolean autocasting' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a Boolean' do
    describe 'with automatic typecasting' do
      before do
        @reader = @connection.create_command('SELECT flags FROM widgets WHERE ad_description = ?').execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(FalseClass)
      end

      it 'returns the correct result' do
        expect(@values.first).to eq false
      end
    end
  end
end

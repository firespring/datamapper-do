shared_examples 'supporting BigDecimal' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a BigDecimal' do
    describe 'with manual typecasting' do
      before do
        @command = @connection.create_command('SELECT cost1 FROM widgets WHERE ad_description = ?')
        @command.set_types(BigDecimal)
        @reader = @command.execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(BigDecimal)
      end

      it 'returns the correct result' do
        # rounding seems necessary for the jruby do_derby driver
        expect(@values.first.round(2)).to eq 10.23
      end
    end

    describe 'with manual typecasting a nil value' do
      before do
        @command = @connection.create_command('SELECT cost2 FROM widgets WHERE id = ?')
        @command.set_types(BigDecimal)
        @reader = @command.execute_reader(6)
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

  describe 'writing an Integer' do
    before do
      @reader = @connection.create_command('SELECT id FROM widgets WHERE id = ?').execute_reader(BigDecimal('2.0'))
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

shared_examples 'supporting BigDecimal autocasting' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a BigDecimal' do
    describe 'with automatic typecasting' do
      before do
        @reader = @connection.create_command('SELECT cost2 FROM widgets WHERE ad_description = ?').execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(BigDecimal)
      end

      it 'returns the correct result' do
        expect(@values.first).to eq 50.23
      end
    end
  end
end

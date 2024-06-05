shared_examples 'supporting Float' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a Float' do
    describe 'with manual typecasting' do
      before do
        @command = @connection.create_command('SELECT id FROM widgets WHERE ad_description = ?')
        @command.set_types(Float)
        @reader = @command.execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(Float)
      end

      it 'returns the correct result' do
        # Some of the drivers starts auto-incrementation from 0 not 1
        expect(@values.first).to(satisfy { |val| [1.0, 0.0].include?(val) })
      end
    end

    describe 'with manual typecasting a nil' do
      before do
        @command = @connection.create_command('SELECT cost1 FROM widgets WHERE id = ?')
        @command.set_types(Float)
        @reader = @command.execute_reader(5)
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

  describe 'writing a Float' do
    before do
      @reader = @connection.create_command('SELECT id FROM widgets WHERE id = ?').execute_reader(2.0)
      @reader.next!
      @values = @reader.values
    end

    after do
      @reader.close
    end

    it 'returns the correct entry' do
      # Some of the drivers starts auto-incrementation from 0 not 1
      expect(@values.first).to(satisfy { |val| [1, 2].include?(val) })
    end
  end
end

shared_examples 'supporting Float autocasting' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a Float' do
    describe 'with automatic typecasting' do
      before do
        @reader = @connection.create_command('SELECT weight, cost1 FROM widgets WHERE ad_description = ?').execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(Float)
        expect(@values.last).to be_kind_of(Float)
      end

      it 'returns the correct result' do
        expect(@values.first).to eq 13.4
        expect(BigDecimal(@values.last.to_s).round(2)).to eq 10.23
      end
    end
  end
end

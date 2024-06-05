shared_examples 'supporting ByteArray' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a ByteArray' do
    describe 'with automatic typecasting' do
      before do
        @reader = @connection.create_command('SELECT cad_drawing FROM widgets WHERE ad_description = ?').execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(Extlib::ByteArray)
      end

      it 'returns the correct result' do
        expect(@values.first).to eq "CAD \001 \000 DRAWING"
      end
    end

    describe 'with manual typecasting' do
      before do
        @command = @connection.create_command('SELECT cad_drawing FROM widgets WHERE ad_description = ?')
        @command.set_types(Extlib::ByteArray)
        @reader = @command.execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(Extlib::ByteArray)
      end

      it 'returns the correct result' do
        expect(@values.first).to eq "CAD \001 \000 DRAWING"
      end
    end
  end

  describe 'writing a ByteArray' do
    before do
      @reader = @connection.create_command('SELECT ad_description FROM widgets WHERE cad_drawing = ?').execute_reader(
        Extlib::ByteArray.new("CAD \001 \000 DRAWING")
      )
      @reader.next!
      @values = @reader.values
    end

    after do
      @reader.close
    end

    it 'returns the correct entry' do
      # Some of the drivers starts auto-incrementation from 0 not 1
      expect(@values.first).to eq 'Buy this product now!'
    end
  end
end

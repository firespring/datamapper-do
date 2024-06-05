shared_examples 'supporting Integer' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading an Integer' do
    describe 'with automatic typecasting' do
      before do
        @reader = @connection.create_command('SELECT id FROM widgets WHERE ad_description = ?').execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(Integer)
      end

      it 'returns the correct result' do
        # Some of the drivers starts auto-incrementation from 0 not 1
        expect(@values.first).to(satisfy { |val| [1, 0].include?(val) })
      end
    end

    describe 'with manual typecasting' do
      before do
        @command = @connection.create_command('SELECT weight FROM widgets WHERE ad_description = ?')
        @command.set_types(Integer)
        @reader = @command.execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(Integer)
      end

      it 'returns the correct result' do
        expect(@values.first).to eq 13
      end
    end
  end

  describe 'writing an Integer' do
    before do
      @reader = @connection.create_command('SELECT id FROM widgets WHERE id = ?').execute_reader(2)
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

  describe 'writing a big Integer' do
    before do
      @connection.create_command('UPDATE widgets SET super_number = ? WHERE id = 10')
                 .execute_non_query(2_147_483_648) # bigger than Integer.MAX in java !!
      @reader = @connection.create_command('SELECT super_number FROM widgets WHERE id = ?').execute_reader(10)
      @reader.next!
      @values = @reader.values
    end

    after do
      @reader.close
    end

    it 'returns the correct entry' do
      expect(@values.first).to eq 2_147_483_648
    end
  end
end

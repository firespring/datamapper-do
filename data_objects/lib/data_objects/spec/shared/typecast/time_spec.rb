shared_examples 'supporting Time' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a Time' do
    describe 'with manual typecasting' do
      before do
        @command = @connection.create_command('SELECT release_date FROM widgets WHERE ad_description = ?')
        @command.set_types(Time)
        @reader = @command.execute_reader('Buy this product now!')
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns the correctly typed result' do
        expect(@values.first).to be_kind_of(Time)
      end

      it 'returns the correct result' do
        expect(@values.first).to eq Time.local(2008, 2, 14)
      end
    end

    describe 'with manual typecasting a nil value' do
      before do
        @command = @connection.create_command('SELECT release_timestamp FROM widgets WHERE id = ?')
        @command.set_types(Time)
        @reader = @command.execute_reader(9)
        @reader.next!
        @values = @reader.values
      end

      after do
        @reader.close
      end

      it 'returns a nil class' do
        expect(@values.first).to be_kind_of(NilClass)
      end

      it 'returns nil' do
        expect(@values.first).to be_nil
      end
    end
  end

  describe 'writing an Time' do
    before do
      @reader = @connection.create_command('SELECT id FROM widgets WHERE release_datetime = ? ORDER BY id').execute_reader(Time.local(
                                                                                                                             2008, 2, 14, 0o0, 31, 12
                                                                                                                           ))
      @reader.next!
      @values = @reader.values
    end

    after do
      @reader.close
    end

    it 'returns the correct entry' do
      # Some of the drivers starts auto-incrementation from 0 not 1
      expect(@values.first).to(satisfy { |val| [1, 0].include?(val) })
    end
  end
end

shared_examples 'supporting sub second Time' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
    @connection.create_command(<<-EOF).execute_non_query(Time.parse('2010-12-15 14:32:08.49377-08').localtime)
      update widgets set release_timestamp = ? where id = 1
    EOF
    @connection.create_command(<<-EOF).execute_non_query(Time.parse('2010-12-15 14:32:28.942694-08').localtime)
      update widgets set release_timestamp = ? where id = 2
    EOF

    @command = @connection.create_command('SELECT release_timestamp FROM widgets WHERE id < ? order by id')
    @command.set_types(Time)
    @reader = @command.execute_reader(3)
    @reader.next!
    @values = @reader.values
  end

  after do
    @connection.close
  end

  it 'handles variable subsecond lengths properly' do
    expect(@values.first.to_f).to be_within(0.00002).of(Time.at(1_292_452_328, 493_770).to_f)
    @reader.next!
    @values = @reader.values
    expect(@values.first.to_f).to be_within(0.00002).of(Time.at(1_292_452_348, 942_694).to_f)
  end
end

shared_examples 'supporting Nil' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a Nil' do
    describe 'with manual typecasting' do
      before do
        @command = @connection.create_command('SELECT flags FROM widgets WHERE ad_description = ?')
        @command.set_types(NilClass)
        @reader = @command.execute_reader('Buy this product now!')
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
end

shared_examples 'supporting writing an Nil' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'supporting writing an Nil' do
    # see as an example oracle
    # http://download.oracle.com/docs/cd/B19306_01/server.102/b14200/sql_elements005.htm#sthref487
    # http://download.oracle.com/docs/cd/B19306_01/server.102/b14200/conditions013.htm#i1050801

    describe 'as a parameter' do
      before do
        @reader = @connection.create_command('SELECT id FROM widgets WHERE ad_description IN (?) ORDER BY id').execute_reader(nil)
      end

      after do
        @reader.close
      end

      it 'returns the correct entry' do
        expect(@reader.next!).to be false
      end
    end
  end
end

shared_examples 'supporting Nil autocasting' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  describe 'reading a Nil' do
    describe 'with automatic typecasting' do
      before do
        @reader = @connection.create_command('SELECT ad_description FROM widgets WHERE id = ?').execute_reader(3)
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
end

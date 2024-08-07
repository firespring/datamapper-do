def test_connection(conn)
  reader = conn.create_command(CONFIG.testsql || 'SELECT 1').execute_reader
  reader.next!
  result = reader.values[0]
  result
ensure
  reader.close
  conn.close
end

shared_examples 'a Connection' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
  end

  after do
    @connection.close
  end

  it { expect(@connection).to be_kind_of(DataObjects::Connection) }
  it { expect(@connection).to be_kind_of(DataObjects::Pooling) }

  it { expect(@connection).to respond_to(:dispose) }
  it 'responds to #create_command' do
    expect(@connection).to respond_to(:create_command)
  end

  describe 'create_command' do
    it 'is a kind of Command' do
      expect(@connection.create_command('This is a dummy command')).to be_kind_of(DataObjects::Command)
    end
  end

  describe 'various connection URIs' do
    it 'opens with an uri object' do
      uri = DataObjects::URI.new(
        scheme: @driver,
        user: @user,
        password: @password,
        host: @host,
        port: @port&.to_i,
        path: @database
      )
      conn = DataObjects::Connection.new(uri)
      expect(test_connection(conn)).to eq 1
      conn.close
    end

    it 'works with non-JDBC URLs' do
      conn = DataObjects::Connection.new(CONFIG.uri.sub('jdbc:', '').to_s)
      expect(test_connection(conn)).to eq 1
      conn.close
    end
  end

  describe 'dispose' do
    describe 'on open connection' do
      it 'dispose is true' do
        conn = DataObjects::Connection.new(CONFIG.uri)
        conn.detach
        expect(conn.dispose).to be true
        conn.close
      end
    end

    describe 'on closed connection' do
      before do
        @closed_connection = DataObjects::Connection.new(CONFIG.uri)
        @closed_connection&.detach
        @closed_connection&.dispose
      end

      after do
        @closed_connection&.close
        @closed_connection = nil
      end

      it { expect(@closed_connection&.dispose).to be false }

      it 'raises an error on creating a command' do
        expect do
          @closed_connection&.create_command('INSERT INTO non_existent_table (tester) VALUES (1)')&.execute_non_query
        end.to raise_error(DataObjects::ConnectionError)
      end
    end
  end
end

shared_examples 'a Connection with authentication support' do
  before :all do
    %w(@driver @user @password @host @port @database).each do |ivar|
      raise "+#{ivar}+ should be defined in before block" unless instance_variable_get(ivar)
    end
  end

  describe 'with an invalid URI' do
    it 'raises an error if bad username is given' do
      expect { DataObjects::Connection.new("#{@driver}://thisreallyshouldntexist:#{@password}@#{@host}:#{@port}#{@database}") }
        .to raise_error(DataObjects::ConnectionError)
    end

    it 'raises an error if bad password is given' do
      expect { DataObjects::Connection.new("#{@driver}://#{@user}:completelyincorrectpassword:#{@host}:#{@port}#{@database}") }
        .to raise_error(DataObjects::SQLError)
    end

    it 'raises an error if an invalid port is given' do
      expect { DataObjects::Connection.new("#{@driver}://#{@user}:#{@password}:#{@host}:648646543#{@database}") }.to raise_error(DataObjects::SQLError)
    end

    it 'raises an error if an invalid database is given' do
      expect { DataObjects::Connection.new("#{@driver}://#{@user}:#{@password}:#{@host}:#{@port}/someweirddatabase") }.to raise_error(DataObjects::SQLError)
    end
  end
end

shared_examples 'a Connection allowing default database' do
  describe 'with a URI without a database' do
    it 'connects properly' do
      conn = DataObjects::Connection.new("#{@driver}://#{@user}:#{@password}@#{@host}:#{@port}")
      expect(test_connection(conn)).to eq 1
    end
  end
end

shared_examples 'a Connection with SSL support' do
  if DataObjectsSpecHelpers.test_environment_supports_ssl?
    describe 'connecting with SSL' do
      it 'connects securely' do
        conn = DataObjects::Connection.new("#{CONFIG.uri}?#{CONFIG.ssl}")
        expect(conn.secure?).to be true
        conn.close
      end
    end
  end

  describe 'connecting without SSL' do
    it 'does not connect securely' do
      conn = DataObjects::Connection.new(CONFIG.uri)
      expect(conn.secure?).to be false
      conn.close
    end
  end
end

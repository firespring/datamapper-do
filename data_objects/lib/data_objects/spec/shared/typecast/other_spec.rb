class ::CustomTextType
  def initialize(value)
    @value = value
  end

  def to_s
    @value.to_s
  end
end

shared_examples 'supporting other (unknown) type' do
  before :all do
    setup_test_environment
  end

  describe 'writing an object of unknown type' do
    before do
      @connection = DataObjects::Connection.new(CONFIG.uri)
    end

    after do
      @connection.close
    end

    before do
      @command = @connection.create_command('SELECT ad_description FROM widgets WHERE ad_description = ?')
      @command.set_types(CustomTextType)
      @reader = @command.execute_reader('Buy this product now!')
      @reader.next!
      @values = @reader.values
    end

    after do
      @reader.close
    end

    it 'returns the correct entry' do
      expect(@values.first).to eq 'Buy this product now!'
    end
  end
end

shared_examples 'a Reader' do
  before :all do
    setup_test_environment
  end

  before do
    @connection = DataObjects::Connection.new(CONFIG.uri)
    @reader     = @connection.create_command('SELECT code, name FROM widgets WHERE ad_description = ? order by id')
                             .execute_reader('Buy this product now!')
    @reader2    = @connection.create_command('SELECT code FROM widgets WHERE ad_description = ? order by id').execute_reader('Buy this product now!')
  end

  after do
    @reader.close
    @reader2.close
    @connection.close
  end

  it { expect(@reader).to respond_to(:fields) }

  describe 'fields' do
    it 'returns the correct fields in the reader' do
      # we downcase the field names as some drivers such as do_derby, do_h2,
      # do_hsqldb, do_oracle return the field names as uppercase
      expect(@reader.fields).to be_array_case_insensitively_equal_to(%w(code name))
    end

    it 'returns the field alias as the name, when the SQL AS keyword is specified' do
      reader = @connection.create_command('SELECT code AS codigo, name AS nombre FROM widgets WHERE ad_description = ? order by id')
                          .execute_reader('Buy this product now!')
      expect(reader.fields).not_to be_array_case_insensitively_equal_to(%w(code name))
      expect(reader.fields).to be_array_case_insensitively_equal_to(%w(codigo nombre))
      reader.close
    end
  end

  it { expect(@reader).to respond_to(:values) }

  describe 'values' do
    describe 'when the reader is uninitialized' do
      it 'raises an error' do
        expect { @reader.values }.to raise_error(DataObjects::DataError)
      end
    end

    describe 'when the reader is moved to the first result' do
      before do
        @reader.next!
      end

      it 'returns the correct first set of in the reader' do
        expect(@reader.values).to eq ['W0000001', 'Widget 1']
      end
    end

    describe 'when the reader is moved to the second result' do
      before do
        @reader.next!
        @reader.next!
      end

      it 'returns the correct first set of in the reader' do
        expect(@reader.values).to eq ['W0000002', 'Widget 2']
      end
    end

    describe 'when the reader is moved to the end' do
      before do
        while @reader.next!; end
      end

      it 'raises an error again' do
        expect { @reader.values }.to raise_error(DataObjects::DataError)
      end
    end
  end

  it { expect(@reader).to respond_to(:close) }

  describe 'close' do
    describe 'on an open reader' do
      it 'returns true' do
        expect(@reader.close).to be true
      end
    end

    describe 'on an already closed reader' do
      before do
        @reader.close
      end

      it 'returns false' do
        expect(@reader.close).to be false
      end
    end
  end

  it { expect(@reader).to respond_to(:next!) }

  describe 'next!' do
    describe 'successfully moving the cursor initially' do
      it 'returns true' do
        expect(@reader.next!).to be true
      end
    end

    describe 'moving the cursor' do
      before do
        @reader.next!
      end

      it 'moves the cursor to the next value' do
        expect(@reader.values).to eq ['W0000001', 'Widget 1']
        expect { @reader.next! }.to(change { @reader.values })
        expect(@reader.values).to eq ['W0000002', 'Widget 2']
      end
    end

    describe 'arriving at the end of the reader' do
      before do
        while @reader.next!; end
      end

      it 'returns false when the end is reached' do
        expect(@reader.next!).to be false
      end
    end
  end

  it { expect(@reader).to respond_to(:field_count) }

  describe 'field_count' do
    it 'counts the number of fields' do
      expect(@reader.field_count).to eq 2
    end
  end

  it { expect(@reader).to respond_to(:values) }

  describe 'each' do
    it 'yields each row to the block for multiple columns' do
      rows_yielded = 0
      @reader.each do |row|
        expect(row).to respond_to(:[])

        expect(row.size).to eq 2

        # the field names need to be case insensitive as some drivers such as
        # do_derby, do_h2, do_hsqldb return the field names as uppercase
        expect(row['name'] || row['NAME']).to be_kind_of(String)
        expect(row['code'] || row['CODE']).to be_kind_of(String)

        rows_yielded += 1
      end
      expect(rows_yielded).to eq 15
    end

    it 'yields each row to the block for a single column' do
      rows_yielded = 0
      @reader2.each do |row|
        expect(row).to respond_to(:[])

        expect(row.size).to eq 1

        # the field names need to be case insensitive as some drivers such as
        # do_derby, do_h2, do_hsqldb return the field names as uppercase
        expect(row['code'] || row['CODE']).to be_kind_of(String)

        rows_yielded += 1
      end
      expect(rows_yielded).to eq 15
    end

    it 'returns the reader' do
      expect(@reader.each do |_row|
        # empty block
      end).to equal(@reader)
    end
  end
end

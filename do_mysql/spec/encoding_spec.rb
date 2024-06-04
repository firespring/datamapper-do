require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'data_objects/spec/shared/encoding_spec'

describe DataObjects::Mysql::Connection do
  it_behaves_like 'a driver supporting different encodings'
  it_behaves_like 'returning correctly encoded strings for the default database encoding'
  it_behaves_like 'returning correctly encoded strings for the default internal encoding' unless JRUBY

  unless JRUBY
    describe 'sets the character set through the URI' do
      before do
        @utf8mb4_connection = DataObjects::Connection.new(
          "#{CONFIG.scheme}://#{CONFIG.user}:#{CONFIG.pass}@#{CONFIG.host}:#{CONFIG.port}#{CONFIG.database}?encoding=UTF-8-MB4"
        )
      end

      after { @utf8mb4_connection.close }

      it { expect(@utf8mb4_connection.character_set).to eq 'UTF-8-MB4' }

      describe 'writing a multibyte String' do
        it 'writes a multibyte String' do
          @command = @utf8mb4_connection.create_command('INSERT INTO users_mb4 (name) VALUES(?)')
          expect { @command.execute_non_query('😀') }.not_to raise_error(DataObjects::DataError)
        end
      end

      describe 'reading a String' do
        before do
          @reader = @utf8mb4_connection.create_command('SELECT name FROM users_mb4').execute_reader
          @reader.next!
          @values = @reader.values
        end

        after do
          @reader.close
        end

        it 'returns a UTF-8 encoded String' do
          expect(@values.first).to be_kind_of(String)
          expect(@values.first.encoding.name).to eq 'UTF-8'
          expect(@values.first).to eq '😀'
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength

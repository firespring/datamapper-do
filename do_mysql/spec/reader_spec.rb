require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'data_objects/spec/shared/reader_spec'

describe DataObjects::Mysql::Reader do
  it_behaves_like 'a Reader'

  describe 'reading database metadata' do
    subject { reader }

    let(:connection) { DataObjects::Connection.new(CONFIG.uri) }
    let(:command) { connection.create_command(sql) }
    let(:reader) { command.execute_reader }

    after do
      reader.close
      connection.close
    end

    describe 'showing correct column field names for a table' do
      let(:sql) { 'SHOW COLUMNS FROM `widgets`' }
      its(:fields) { is_expected.to eq %w(Field Type Null Key Default Extra) }
    end

    describe 'showing correct column field names for variables' do
      let(:sql) { "SHOW VARIABLES LIKE 'character_set_connection'" }
      its(:fields) { is_expected.to eq %w(Variable_name Value) }
    end
  end
end

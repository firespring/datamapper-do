require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'data_objects/spec/shared/typecast/integer_spec'

describe 'DataObjects::Sqlite3 with Integer' do
  it_should_behave_like 'supporting Integer'
end

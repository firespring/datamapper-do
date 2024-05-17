require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'data_objects/spec/shared/typecast/byte_array_spec'

describe 'DataObjects::Mysql with ByteArray' do
  it_behaves_like 'supporting ByteArray'
end

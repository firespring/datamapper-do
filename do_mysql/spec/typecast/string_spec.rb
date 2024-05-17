require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'data_objects/spec/shared/typecast/string_spec'

describe 'DataObjects::Mysql with String' do
  it_behaves_like 'supporting String'
end

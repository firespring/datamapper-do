require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'data_objects/spec/shared/typecast/integer_spec'

describe 'DataObjects::Mysql with Integer' do
  it_behaves_like 'supporting Integer'
end

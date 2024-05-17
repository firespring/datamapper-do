require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'data_objects/spec/shared/typecast/class_spec'

describe 'DataObjects::Mysql with Class' do
  it_behaves_like 'supporting Class'
end

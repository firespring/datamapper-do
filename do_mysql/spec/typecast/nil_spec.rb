require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'data_objects/spec/shared/typecast/nil_spec'

describe 'DataObjects::Mysql with Nil' do
  it_behaves_like 'supporting Nil'
  it_behaves_like 'supporting writing an Nil'
  it_behaves_like 'supporting Nil autocasting'
end

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'data_objects/spec/shared/typecast/float_spec'

describe 'DataObjects::Mysql with Float' do
  it_behaves_like 'supporting Float'
  it_behaves_like 'supporting Float autocasting'
end

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'data_objects/spec/shared/typecast/bigdecimal_spec'

describe 'DataObjects::Mysql with BigDecimal' do
  it_behaves_like 'supporting BigDecimal'
  it_behaves_like 'supporting BigDecimal autocasting'
end

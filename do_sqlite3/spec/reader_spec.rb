require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'data_objects/spec/shared/reader_spec'

describe DataObjects::Sqlite3::Reader do
  it_behaves_like 'a Reader'
end

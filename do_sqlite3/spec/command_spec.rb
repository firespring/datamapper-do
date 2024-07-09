require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'data_objects/spec/shared/command_spec'

describe DataObjects::Sqlite3::Command do
  it_behaves_like 'a Command'
end

require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'data_objects/spec/shared/command_spec'

describe DataObjects::Mysql::Command do
  it_behaves_like 'a Command'
  it_behaves_like 'a Command with async'
end

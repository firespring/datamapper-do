require 'data_objects'

begin
  require 'do_sqlite3/do_sqlite3'
rescue LoadError
  raise unless RUBY_PLATFORM =~ /mingw|mswin/

  RUBY_VERSION =~ /(\d+.\d+)/
  require "do_sqlite3/#{Regexp.last_match(1)}/do_sqlite3"
end

require 'do_sqlite3/version'
require 'do_sqlite3/transaction'

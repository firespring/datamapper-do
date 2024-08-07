require 'data_objects'

begin
  require 'do_mysql/do_mysql'
rescue LoadError
  raise unless RUBY_PLATFORM =~ /mingw|mswin/

  RUBY_VERSION =~ /(\d+.\d+)/
  require "do_mysql/#{Regexp.last_match(1)}/do_mysql"
end

require 'do_mysql/version'
require 'do_mysql/transaction'
require 'do_mysql/encoding'

module DataObjects
  module Mysql
    class Connection
      def secure?
        !(@ssl_cipher.nil? || @ssl_cipher.empty?)
      end
    end
  end
end

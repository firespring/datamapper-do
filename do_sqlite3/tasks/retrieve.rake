begin
  gem 'rake-compiler', '~>1.2'
  require 'rake/clean'
  require 'rake/extensioncompiler'

  # required folder structure for --with-sqlite3-dir (include + lib)
  directory 'vendor/sqlite3/lib'
  directory 'vendor/sqlite3/include'

  # clobber vendored packages
  CLOBBER.include('vendor')

  # vendor:sqlite3
  task 'vendor:sqlite3' => %w[vendor/sqlite3/lib/sqlite3.lib vendor/sqlite3/include/sqlite3.h]
rescue LoadError
end

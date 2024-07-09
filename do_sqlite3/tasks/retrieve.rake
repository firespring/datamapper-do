begin
  gem 'rake-compiler', '~>1.2'
  require 'rake/clean'
  require 'rake/extensioncompiler'

  # download sqlite3 library and headers

  # only on Windows or cross platform compilation

  # required folder structure for --with-sqlite3-dir (include + lib)
  directory 'vendor/sqlite3/lib'
  directory 'vendor/sqlite3/include'

  # download amalgamation BINARY_VERSION (for include files)

  # download dll binaries

  # extract header files into include folder

  # extract dll files into lib folder

  # generate import library from definition and dll file

  # clobber vendored packages
  CLOBBER.include('vendor')

  # vendor:sqlite3
  task 'vendor:sqlite3' => %w[vendor/sqlite3/lib/sqlite3.lib vendor/sqlite3/include/sqlite3.h]

  # hook into cross compilation vendored sqlite3 dependency
rescue LoadError
end

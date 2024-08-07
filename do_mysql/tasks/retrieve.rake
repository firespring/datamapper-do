begin
  gem 'rake-compiler', '~>1.2'
  require 'rake/clean'
  require 'rake/extensioncompiler'

  # download mysql library and headers
  directory 'vendor'

  # only on Windows or cross platform compilation



  # clobber vendored packages
  CLOBBER.include('vendor')

  # vendor:mysql

  # hook into cross compilation vendored mysql dependency
rescue LoadError
end

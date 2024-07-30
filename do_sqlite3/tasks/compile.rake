begin
  gem 'rake-compiler', '~>1.2'
  require 'rake/extensiontask'

  def gemspec
    @gemspec ||= Gem::Specification.load(File.expand_path('../do_sqlite3.gemspec', __dir__))
  end

  Rake::ExtensionTask.new('do_sqlite3', gemspec) do |ext|
    sqlite3_lib = File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'sqlite3'))

    ext.lib_dir = "lib/#{gemspec.name}"

    ext.cross_config_options << "--with-sqlite3-dir=#{sqlite3_lib}"
    ext.cross_config_options << "--with-sqlite3-include=#{sqlite3_lib}/include"
    ext.cross_config_options << "--with-sqlite3-lib=#{sqlite3_lib}/lib"


    # automatically add build options to avoid need of manual input
  end
rescue LoadError
  warn 'To compile, install rake-compiler (gem install rake-compiler)'
end

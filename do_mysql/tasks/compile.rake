begin
  gem 'rake-compiler', '~>1.2'
  require 'rake/extensiontask'

  def gemspec
    @gemspec ||= Gem::Specification.load(File.expand_path('../do_mysql.gemspec', __dir__))
  end

  Rake::ExtensionTask.new('do_mysql', gemspec) do |ext|
    ext.lib_dir = "lib/#{gemspec.name}"

    # automatically add build options to avoid need of manual input
  end
rescue LoadError
  warn 'To compile, install rake-compiler (gem install rake-compiler)'
end

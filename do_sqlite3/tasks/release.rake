desc 'Builds all gems (native, binaries for JRuby and Windows)'
task :build_all do
  `rake clean`
  `rake build`
  `rake cross native gem RUBY_CC_VERSION=2.7.8:3.2.2`
end

desc 'Release all gems (native, binaries for JRuby and Windows)'
task release_all: :build_all do
  Dir["pkg/do_sqlite3-#{DataObjects::Sqlite3::VERSION}*.gem"].each do |gem_path|
    command = "gem push #{gem_path}"
    puts "Executing #{command.inspect}:"
    sh command
  end
end

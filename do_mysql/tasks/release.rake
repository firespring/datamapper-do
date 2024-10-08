desc 'Builds all gems (native, binaries for JRuby and Windows)'
task :build_all do
  `rake clean`
  `rake build`
end

desc 'Release all gems (native, binaries for JRuby and Windows)'
task release_all: :build_all do
  Dir.children("pkg").each do |gem_path|
    command = "gem push pkg/#{gem_path}"
    puts "Executing #{command.inspect}:"
    sh command
  end
end

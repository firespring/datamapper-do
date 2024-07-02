require 'pathname'
require 'rubygems'
require 'rake'
require 'rubygems/package_task'

ROOT     = Pathname(__FILE__).dirname.expand_path
SUDO     = 'sudo' unless ENV['SUDOLESS']

# RCov is run by default, except on the JRuby and IronRuby platforms, or if NO_RCOV env is true
RUN_RCOV = (ENV.key?('NO_RCOV') ? ENV['NO_RCOV'] != 'true' : true)

projects = %w(data_objects do_mysql do_sqlite3)
def rake(cmd)
  ruby "-S rake #{cmd}", verbose: false
end

desc 'Release all do gems'
task :release do
  (projects).uniq.each do |dir|
    Dir.chdir(dir) { rake 'release_all' }
  end
end

tasks = {
  install: 'Install the do gems',
  build_all: 'Package the do gems',
  clean: 'clean temporary files',
  clobber: 'clobber temporary files'
}

task default: [:spec]

desc 'Run all the specs for the subprojects'
task :spec do
  commands = ['mysql -u root -e "create database do_test;"']

  commands.each { |command| `#{command}` }

  spec_projects = %w(data_objects do_mysql do_sqlite3)
  spec_projects.each do |gem_name|
    Dir.chdir(gem_name) { rake :spec }
  end
end

desc 'Bump version numbers, needs OLD and NEW environment variables'
task :bump do
  old_version = ENV.fetch('OLD', nil)
  new_version = ENV.fetch('NEW', nil)

  raise 'Specify versions when bumping: OLD=x.y.z NEW=x.y.z+1 rake bump' unless old_version && new_version

  # Remove any Gemfile.lock files
  Dir['**/Gemfile.lock'].each do |f|
    File.delete f
  end

  Dir['**/*.gemspec', '**/version.rb', '**/compile.rake', '**/Gemfile'].each do |filename|
    text = File.read(filename)
    out  = text.gsub(/#{old_version}/, new_version)
    File.open(filename, 'w') { |file| file << out }
  end
end

tasks.each do |name, description|
  desc description
  task name do
    projects.each do |gem_name|
      Dir.chdir(gem_name) { rake name }
    end
  end
end

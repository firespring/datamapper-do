begin
  gem 'rake-compiler', '~>0.7'
  require 'rake/clean'
  require 'rake/extensioncompiler'

  # download sqlite3 library and headers

  # only on Windows or cross platform compilation
  def dlltool(dllname, deffile, libfile)
    # define if we are using GCC or not
    if Rake::ExtensionCompiler.mingw_gcc_executable
      dir = File.dirname(Rake::ExtensionCompiler.mingw_gcc_executable)
      tool = case RUBY_PLATFORM
             when /mingw/
               File.join(dir, 'dlltool.exe')
             when /linux|darwin/
               File.join(dir, "#{Rake::ExtensionCompiler.mingw_host}-dlltool")
             end
      "#{tool} --dllname #{dllname} --def #{deffile} --output-lib #{libfile}"
    else
      raise 'Unsupported platform for cross-compilation (please, contribute some patches).' unless RUBY_PLATFORM =~ /mswin/

      tool = 'lib.exe'

      "#{tool} /DEF:#{deffile} /OUT:#{libfile}"
    end
  end

  # required folder structure for --with-sqlite3-dir (include + lib)
  directory 'vendor/sqlite3/lib'
  directory 'vendor/sqlite3/include'

  # download amalgamation BINARY_VERSION (for include files)
  file "vendor/sqlite-amalgamation-#{BINARY_VERSION}.zip" => ['vendor'] do |t|
    url = "http://www.sqlite.org/#{Date.today.year}/#{File.basename(t.name)}"
    when_writing "downloading #{t.name}" do
      cd File.dirname(t.name) do
        system "wget -c #{url} || curl -L -C - -O #{url}"
      end
    end
  end

  # download dll binaries
  file "vendor/sqlite-dll-win32-x86-#{BINARY_VERSION}.zip" => ['vendor'] do |t|
    url = "http://www.sqlite.org/#{Date.today.year}/#{File.basename(t.name)}"
    when_writing "downloading #{t.name}" do
      cd File.dirname(t.name) do
        system "wget -c #{url} || curl -L -C - -O #{url}"
      end
    end
  end

  # extract header files into include folder
  file 'vendor/sqlite3/include/sqlite3.h' => ['vendor/sqlite3/include', "vendor/sqlite-amalgamation-#{BINARY_VERSION}.zip"] do |t|
    full_file = File.expand_path(t.prerequisites.last)
    when_writing "creating #{t.name}" do
      cd File.dirname(t.name) do
        sh "unzip -j #{full_file}"
        # update file timestamp to avoid Rake perform this extraction again.
        touch File.basename(t.name)
      end
    end
  end

  # extract dll files into lib folder
  file 'vendor/sqlite3/lib/sqlite3.dll' => ['vendor/sqlite3/lib', "vendor/sqlite-dll-win32-x86-#{BINARY_VERSION}.zip"] do |t|
    full_file = File.expand_path(t.prerequisites.last)
    when_writing "creating #{t.name}" do
      cd File.dirname(t.name) do
        sh "unzip -j #{full_file}"
        # update file timestamp to avoid Rake perform this extraction again.
        touch File.basename(t.name)
      end
    end
  end

  # generate import library from definition and dll file
  file 'vendor/sqlite3/lib/sqlite3.lib' => ['vendor/sqlite3/lib/sqlite3.dll'] do |t|
    libfile = t.name
    dllname = libfile.ext('dll')
    deffile = libfile.ext('def')

    when_writing "creating #{t.name}" do
      sh dlltool(dllname, deffile, libfile)
    end
  end

  # clobber vendored packages
  CLOBBER.include('vendor')

  # vendor:sqlite3
  task 'vendor:sqlite3' => ['vendor/sqlite3/lib/sqlite3.lib', 'vendor/sqlite3/include/sqlite3.h']

  # hook into cross compilation vendored sqlite3 dependency
  if RUBY_PLATFORM =~ /mingw|mswin/
    Rake::Task['compile'].prerequisites.unshift 'vendor:sqlite3'
  elsif Rake::Task.tasks.map { |t| t.name }.include? 'cross'
    Rake::Task['cross'].prerequisites.unshift 'vendor:sqlite3'
  end
rescue LoadError
end

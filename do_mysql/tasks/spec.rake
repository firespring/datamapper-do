require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(spec: %i[clean compile]) do |spec|
  spec.pattern = './spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(rcov: %i[clean compile]) do |rcov|
  rcov.pattern    = './spec/**/*_spec.rb'
  rcov.rcov       = true
  rcov.rcov_opts  = File.read('spec/rcov.opts').split(/\s+/)
end

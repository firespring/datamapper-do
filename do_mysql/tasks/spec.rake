require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(spec: %i(clean compile)) do |spec|
  spec.pattern = './spec/**/*_spec.rb'

  require 'simplecov'
  SimpleCov.start do
    minimum_coverage 100
  end
end

namespace :ssl do
  task :env do
    require ROOT.join('spec', 'spec_helper')
  end

  desc 'Check test environment for SSL support.'
  task check: :env do
    DataObjectsSpecHelpers.test_environment_supports_ssl?

    puts
    if DataObjectsSpecHelpers.test_environment_supports_ssl?
      puts '** SSL successfully configured for the test environment **'
    else
      puts '** SSL is not configured for the test environment **'
      puts
      puts DataObjectsSpecHelpers.test_environment_ssl_config_errors.join("\n")
      puts
      raise 'Run rake ssl:config for instructions on how to configure the test environment.'
    end
  end

  desc 'Provide instructions on how to configure SSL in your test environment.'
  task config: :env do
    puts DataObjectsSpecHelpers.test_environment_ssl_config
  end
end

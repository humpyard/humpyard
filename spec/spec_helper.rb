require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"

  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
  require 'rspec/rails'

  Rails.backtrace_cleaner.remove_silencers!

  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true
  end
end

Spork.each_run do
  Rails.application.reload_routes!
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }  
end


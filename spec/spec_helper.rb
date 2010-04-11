ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../test/rails/config/environment" unless defined?(Rails.root)
require 'rspec/rails'
require 'rspec/rails/transactional_database_support'
require 'rspec/core/configuration.rb'

require 'factory_girl'
Dir.glob(File.join(File.dirname(__FILE__), '../test/factories/**/*.rb')).each {|f| require f }  

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Rspec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_examples = false
  config.color_enabled = true
  config.formatter = 'doc'
end

def rails_root_mtime
  Time.zone.at(::File.new("#{Rails.root}").mtime)
end


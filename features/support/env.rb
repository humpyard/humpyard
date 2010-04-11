$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../test/rails/config/environment")
require 'rails/test_help'

begin
  gem "test-unit"
rescue LoadError
end

require 'rspec'
require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'rails/test_help'
require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'

require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'
require 'cucumber/rails/capybara_javascript_emulation'

require "markup_validity"

begin
  File.symlink File.dirname(__FILE__)+"/../../test/rails/public", File.dirname(__FILE__)+"/../../public"
  puts "=== Created symlink public -> test/rails/public ==="
rescue Exception => e
  puts "=== The symlink public -> test/rails/public already exists ==="
end

Before do
  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
  
  require 'factory_girl'
  Dir.glob(File.join(File.dirname(__FILE__), '../../test/factories/**/*.rb')).each {|f| require f }  
  
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'test/fake_rails'

require 'humpyard'
require 'spec/expectations'
require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'rails/test_help'
require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'

require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'
require 'cucumber/rails/capybara_javascript_emulation'

Before do
  require 'factory_girl'
  Dir.glob(File.join(File.dirname(__FILE__), '../../test/factories/*.rb')).each {|f| require f }  
  Factory.factories.keys.each {|factory| Factory(factory) }
end

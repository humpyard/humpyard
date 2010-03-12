$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'rails/all'

ENV["RAILS_ENV"] = 'test'

# Fake Rails deps
module ApplicationHelper
end

class ApplicationController < ActionController::Base
  protect_from_forgery
end

module TestHumpYard
  class Application < Rails::Application
    config.filter_parameters << :password
    config.action_controller.session = { :key => "test_session", :secret => "157c580cceca36817277af541b354923" }
    config.cache_classes = true
    config.whiny_nils = true
    config.consider_all_requests_local       = true
    config.action_controller.perform_caching = false
    config.action_controller.allow_forgery_protection    = false
    config.action_mailer.delivery_method = :test
  end
end

TestHumpYard::Application.initialize!

require 'hump_yard'
require 'spec/expectations'
#require 'spec/rails'
#require 'webrat'
require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'rails/test_help'
require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'

require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'
require 'cucumber/rails/capybara_javascript_emulation'

#Webrat.configure do |config|
#  config.mode = :rack
#end

Before do
  require 'factory_girl'
  Dir.glob(File.join(File.dirname(__FILE__), '../../spec/factories/*.rb')).each {|f| require f }  
  Factory.factories.keys.each {|factory| Factory(factory) }
end

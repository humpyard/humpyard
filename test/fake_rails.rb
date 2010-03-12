require 'rails/all'

ENV["RAILS_ENV"] = 'test'

# Fake Rails deps
module ApplicationHelper
end

class ApplicationController < ActionController::Base
  protect_from_forgery
end

module TestHumpyard
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

TestHumpyard::Application.initialize!
